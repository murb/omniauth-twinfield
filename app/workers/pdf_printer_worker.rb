# frozen_string_literal: true

class PdfPrinterWorker
  include Sidekiq::Worker

  attr_reader :options
  attr_reader :url

  sidekiq_options retry: true, backtrace: true, queue: :qkunst_default

  def perform(url, options = {})
    inform_user_id = options[:inform_user_id] || options["inform_user_id"]
    subject_object_id = options[:subject_object_id] || options["subject_object_id"]
    subject_object_type = options[:subject_object_type] || options["subject_object_type"]

    filename = "/tmp/#{SecureRandom.base58(32)}.pdf"

    # urls are recognized as urls, but local files are not; simple trick that works on unixy systems
    resource = if /\A\/tmp\/[A-Za-z]*\//.match?(url)
      "file://#{url}"
    elsif url.start_with? File.join(Rails.root, "public")
      "file://#{url}"
    elsif url.start_with? "https://collectiemanagement.qkunst.nl/"
      url
    else
      raise "Unsecure location (#{url})"
    end

    # setting for debugging purposes
    @url = url
    @options = options

    command = [File.join(Rails.root, "bin", "puppeteer"), resource, filename].join(" ")
    if !system("node --version")
      raise "Node not found. Required."
    end

    Rails.logger.debug ("Start creating a pdf using puppeteer, command: #{command}")
    system(command, exception: true)

    if inform_user_id
      Message.create(to_user_id: inform_user_id, subject_object_id: subject_object_id, subject_object_type: subject_object_type, from_user_name: "Download voorbereider", attachment: File.open(filename), message: "De download is gereed, open het bericht in je browser om de bijlage te downloaden.\n\nFormaat: PDF", subject: "PDF gereed")
    end

    filename
  end
end
