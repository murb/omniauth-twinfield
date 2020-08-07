# frozen_string_literal: true

module Work::Export
  extend ActiveSupport::Concern
  ARTIST_EXPORT_FIELDS = [:id, :alt_number_1, :first_name, :prefix, :last_name, :rkd_artist_id, :year_of_birth, :year_of_death, :artist_name]

  included do
    scope :audience, ->(audience) do
      if audience == :erfgoed_gelderland
        published
      else
        where("1=1")
      end
    end

    5.times do |artist_index|
      ARTIST_EXPORT_FIELDS.each do |artist_property|
        define_method(:"artist_#{artist_index}_#{artist_property}") do
          artists[artist_index]&.send(artist_property)
        end
      end
    end

    def collect_values_for_fields(fields)
      fields.collect do |field|
        value = send(field)
        if value.class == PictureUploader
          value.file ? value.file.filename : nil
        elsif [GeonameSummary].include? value.class
          value.label
        elsif [Collection, ::Collection, User, Currency, Source, Style, Medium, Condition, Subset, Placeability, Cluster, FrameType, Owner, WorkStatus].include? value.class
          value.name
        elsif value.to_s === "Artist::ActiveRecord_Associations_CollectionProxy"
          artist_name_rendered_without_years_nor_locality_semicolon_separated
        elsif /ActiveRecord\_Associations\_CollectionProxy/.match?(value.class.to_s)
          if value.first.is_a? PaperTrail::Version
            "Versie"
          elsif value.first.is_a? ActsAsTaggableOn::Tagging
            value.collect { |a| a.tag.name }.join(";")
          else
            value.collect { |a| a.name }.join(";")
          end
        elsif value.is_a? Hash
          value.to_s
        elsif value.is_a? Array
          value.join(";")
        else
          value
        end
      end
    end
  end

  class_methods do
    def possible_exposable_fields
      return @@possible_exposable_fields if defined? @@possible_exposable_fields

      fields = instance_methods.collect { |method|
        if method.to_s.match(/=/) && !method.to_s.match(/^(before|after|\_|\=|\<|\!|\[|photo_|remote\_|remove\_|defined\_enums|find\_by\_statement\_cache|validation\_context|record\_timestamps|aggregate\_reflections|include\_root\_in\_json|destroyed\_by\_association|attributes|entry_status_description|entry_status|paper_trail|verions|custom_report|messages|tags|custom_contexts|base_tags|preserve_tag_order|tag_|taggings|version)(.*)/) && !method.to_s.match(/(.*)\_(id|ids|attributes|class_name|association_name|cache)\=$/)
          method.to_s.delete("=")
        end
      }.compact

      fields += ["collection_external_reference_code", "cached_tag_list", "location_floor", "information_back", "artist_unknown", "title_unknown", "description", "object_creation_year_unknown", "medium_comments", "no_signature_present", "condition_work_comments", "condition_frame_comments", "other_comments", "source_comments", "purchase_price", "price_reference", "public_description", "internal_comments", "imported_at", "created_at", "updated_at", "external_inventory", "artist_name_rendered", "valuation_on", "market_value", "replacement_value","lognotes"]

      fields = fields.uniq

      5.times do |artist_index|
        ARTIST_EXPORT_FIELDS.each do |artist_property|
          fields << "artist_#{artist_index}_#{artist_property}"
        end
      end

      # sort_according_to_form
      #
      formstring = File.open("app/views/works/_form.html.erb").read
      formstring += File.open("app/views/appraisals/_form.html.erb").read
      fields.sort! do |a, b|
        a1 = formstring.index(":#{a}") || 9999999
        b1 = formstring.index(":#{b}") || 9999999
        a1 <=> b1
      end

      @@possible_exposable_fields = fields.collect { |a| [Work.human_attribute_name(a.to_s), a] }
    end

    def to_workbook(fields = [:id, :title_rendered], collection = nil)
      w = Workbook::Book.new([fields.collect { |a| Work.human_attribute_name_overridden(a, collection) }])
      all.each do |work|
        w.sheet.table << work.collect_values_for_fields(fields)
      end
      w
    end
  end
end
