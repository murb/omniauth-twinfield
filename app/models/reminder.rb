class Reminder < ApplicationRecord
  INTERVAL_UNITS = {"Dagen"=>:days, "Weken"=>:weeks, "Maanden"=>:months, "Jaren"=>:years}

  belongs_to :stage
  belongs_to :collection

  scope :prototypes, ->{ where(collection_id: nil)}
  scope :actual, ->{ where.not(collection_id: nil)}

  validates_presence_of :interval_unit, :interval_length

  has_many :messages

  def collection_stage_stage
    collection.find_state_of_stage(stage)
  end

  def reference_date
    stage.nil? ? created_at.to_date : collection_stage_stage.completed_at
  end

  def next_date
    next_dates.first if next_dates
  end

  def last_sent_at
    last_message = messages.order(:created_at).last
    return last_message.created_at if last_message
  end

  def next_dates(amount=10)
    if reference_date and repeat and collection
      dates = []
      time = 1
      while dates.count < 10
        date = (reference_date + additional_time(time)).to_date
        dates << date if date >= Time.now.to_date
        time += 1
      end
      return dates
    elsif reference_date and collection
      date = (reference_date + additional_time(1)).to_date
      return (date >= Time.now.to_date) ? [date] : []
    end
  end

  def additional_time(multiplier = 1)
    interval_length = (self.interval_length.to_i < 1) ? 1 : self.interval_length
    (interval_length * multiplier).send(interval_unit)
  end

  def to_hash
    hash = JSON.parse(to_json)
    hash['id'] = nil
    hash
  end

  def to_message!
    message = to_message
    message.save if message
  end

  def current_date
    Time.now.to_date
  end

  def send_message_if_current_date_is_next_date!
    if (current_date == next_date) and (messages.sent_at_date(current_date).count == 0)
      self.to_message!
    end
  end

  def text?
    !(text.nil? or text.empty?)
  end

  def to_message
    if collection
      messages.new(
        to_user: User.find_by(email: "veronique@qkunst.nl"),
        qkunst_private: true,
        created_at: current_date,
        subject: "Herinnering: #{name}",
        message: text? ? text : "Deze herinnering heeft geen beschrijving.",
        subject_object: collection
      )
    end
  end
end
