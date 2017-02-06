require 'rails_helper'

RSpec.describe Reminder, type: :model do
  describe "methods" do
    describe "#additional_time" do
      it "should work for all time intervals in INTERVAL_UNITS" do
        Reminder::INTERVAL_UNITS.each do |a,v|
          expect(Reminder.new(interval_unit: v, interval_length: 1).additional_time).to be > 0.seconds
        end
      end
    end
    describe "#next_dates / #next_date" do
      it "should return one date for non repeating" do
        c = collections(:collection_with_stages)
        r = Reminder.create(interval_unit: :year, interval_length: 10, name: "Naam", collection: c)
        expect(r.next_dates).to eq([(r.created_at+10.years).to_date])
      end
      it "should return one date for non repeating" do
        c = collections(:collection_with_stages)
        s1 = stages(:stage1)
        r = Reminder.create(interval_unit: :year, interval_length: 50, name: "Naam", collection: c, stage: s1)
        expect(r.next_dates).to eq([("2000-01-01T12:00".to_time+50.years).to_date])
        expect(r.next_date).to eq(("2000-01-01T12:00".to_time+50.years).to_date)
      end
      it "should return an empty array if the next date for non repeating has already passed" do
        c = collections(:collection_with_stages)
        s1 = stages(:stage1)
        r = Reminder.create(interval_unit: :year, interval_length: 1, name: "Naam", collection: c, stage: s1)
        expect(r.next_dates).to eq([])
        expect(r.next_date).to eq(nil)
      end
      it "should return 10 dates for non repeating" do
        c = collections(:collection_with_stages)
        s1 = stages(:stage1)
        r = Reminder.create(interval_unit: :year, interval_length: 50, name: "Naam", collection: c, stage: s1, repeat: true)
        expect(r.next_dates).to eq([
          ("2000-01-01T12:00".to_time+50.years).to_date,
          ("2000-01-01T12:00".to_time+100.years).to_date,
          ("2000-01-01T12:00".to_time+150.years).to_date,
          ("2000-01-01T12:00".to_time+200.years).to_date,
          ("2000-01-01T12:00".to_time+250.years).to_date,
          ("2000-01-01T12:00".to_time+300.years).to_date,
          ("2000-01-01T12:00".to_time+350.years).to_date,
          ("2000-01-01T12:00".to_time+400.years).to_date,
          ("2000-01-01T12:00".to_time+450.years).to_date,
          ("2000-01-01T12:00".to_time+500.years).to_date
        ])
        expect(r.next_date).to eq(("2000-01-01T12:00".to_time+50.years).to_date)
      end
      it "should return nil for event that hasn't passed yet" do
        c = collections(:collection_with_stages)
        s2 = stages(:stage2a)
        r = Reminder.create(interval_unit: :year, interval_length: 50, name: "Naam", collection: c, stage: s2)
        expect(r.next_dates).to eq(nil)
      end
      it "should return nil if no collection is given" do
        r = Reminder.create(interval_unit: :year, interval_length: 10, name: "Naam")
        expect(r.next_dates).to eq(nil)
        expect(r.next_date).to eq(nil)
      end
    end
    describe "#to_message" do
      it "should return nil if no collection is given" do
        r = Reminder.create(interval_unit: :year, interval_length: 10, name: "Naam")
        expect(r.to_message).to eq(nil)
      end
      it "should return message if collection is given" do
        c = collections(:collection_with_stages)
        r = Reminder.create(interval_unit: :year, interval_length: 10, name: "Naam", text: "Uitgebreid bericht", collection: c)
        expect(r.to_message.to_json).to eq(Message.new(
          subject: "Naam",
          message: "Uitgebreid bericht",
          to_user: User.find_by(email: "veronique@qkunst.nl"),
          created_at: Time.now.to_date,
          qkunst_private: true,
          subject_object: c,
          reminder: r
        ).to_json)
      end
    end
    describe "#to_message!" do
      it "should return nil if no collection is given" do
        message_count_before = Message.count
        r = Reminder.create(interval_unit: :year, interval_length: 10, name: "Naam")
        expect(r.to_message!).to eq(nil)
        expect(Message.count).to eq(message_count_before)
      end
      it "should return message if collection is given" do
        message_count_before = Message.count
        c = collections(:collection_with_stages)
        r = Reminder.create(interval_unit: :year, interval_length: 10, name: "Naam", text: "Uitgebreid bericht", collection: c)
        expect(r.to_message!.class).to be_truthy
        expect(Message.count).to eq(message_count_before+1)
      end
    end
    describe "#send_message_if_current_date_is_next_date!" do
      it "should not send any message when next_date is not equal to now" do
        message_count_before = Message.count
        c = collections(:collection_with_stages)
        r = Reminder.create(interval_unit: :year, interval_length: 50, name: "Naam", collection: c)
        expect(r.send_message_if_current_date_is_next_date!).to eq(nil)
        expect(Message.count).to eq(message_count_before)
      end
      it "should send any message when next_date is equal to now" do
        message_count_before = Message.count
        c = collections(:collection_with_stages)
        r = Reminder.create(interval_unit: :year, interval_length: 50, name: "Naam", collection: c)
        allow(r).to receive(:current_date).and_return (r.created_at+50.years).to_date
        expect(r.current_date).to eq((r.created_at+50.years).to_date)
        expect(r.next_date).to eq((r.created_at+50.years).to_date)
        expect(r.send_message_if_current_date_is_next_date!).to eq(true)
        expect(Message.count).to eq(message_count_before+1)
      end
      it "should not double send any message when next_date is equal to now" do
        message_count_before = Message.count
        c = collections(:collection_with_stages)
        r = Reminder.create(interval_unit: :year, interval_length: 50, name: "Naam", collection: c)
        allow(r).to receive(:current_date).and_return (r.created_at+50.years).to_date
        expect(r.current_date).to eq((r.created_at+50.years).to_date)
        expect(r.next_date).to eq((r.created_at+50.years).to_date)
        expect(r.send_message_if_current_date_is_next_date!).to eq(true)
        expect(Message.count).to eq(message_count_before+1)
        expect(r.send_message_if_current_date_is_next_date!).to eq(nil)
        expect(Message.count).to eq(message_count_before+1)
      end
    end
  end
end