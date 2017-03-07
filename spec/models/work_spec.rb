require 'rails_helper'

RSpec.describe Work, type: :model do
  describe "instance methods" do
    describe "#height" do
      it "should accept integer" do
        w = works(:work1)
        w.height = 1
        w.save
        w.reload
        expect(w.height).to eq 1.0
      end
      it "should accept string" do
        w = works(:work1)
        w.height = "12"
        w.save
        w.reload
        expect(w.height).to eq 12.0
      end
      it "should accept us-localized string" do
        w = works(:work1)
        w.height = "12.1"
        w.save
        w.reload
        expect(w.height).to eq 12.1
      end
      it "should accept nl-localized string" do
        w = works(:work1)
        w.height = "12,1"
        w.save
        w.reload
        expect(w.height).to eq 12.1
      end
      it "should accept long nl-localized string" do
        w = works(:work1)
        w.height = "12.012,1"
        w.save
        w.reload
        expect(w.height).to eq 12012.1
      end
    end
  end
  describe  "class methods" do
    describe ".aggregations" do
      it "should allow to be initialized" do
        works = [works(:work1),works(:work2)]
        # expect()
        aggregations = Work.aggregations [:title, :themes, :subset, :grade_within_collection]
        expect(aggregations.count).to eq 4
        expect(aggregations[:title][:work1][:count]).to eq 1
        expect(aggregations[:themes][themes(:wind)][:count]).to eq 2
        expect(aggregations[:grade_within_collection][:a][:count]).to eq 2

      end
    end
    describe ".artist_name_rendered" do
      it "should summarize the artists nicely" do
        works(:work1).save
        expect(works(:work1).artist_name_rendered).to eq("artist_1, firstname (1900 - 2000)")
      end
      it "should respect include_years option" do
        works(:work1).save
        expect(works(:work1).artist_name_rendered(include_years: false)).to eq("artist_1, firstname")
      end
    end
    describe ".fast_aggregations" do
      it "should allow to be initialized" do
        works = [works(:work1),works(:work2)]
        # expect()
        aggregations = Work.fast_aggregations [:title, :themes, :subset, :grade_within_collection]
        expect(aggregations.count).to eq 4
        expect(aggregations[:title][:work1][:count]).to eq 999999
        expect(aggregations[:themes][themes(:wind)][:count]).to eq 999999
        expect(aggregations[:grade_within_collection][:a][:count]).to eq 999999
        expect(aggregations[:grade_within_collection][:h]).to eq nil
      end
    end
    describe ".whd_to_s" do
      it "should render nil if all are nil" do
        expect(Work.new.whd_to_s).to eq("")
      end
      it "should render w x h x d if set" do
        expect(Work.new.whd_to_s(1, 2, 3)).to eq("1 x 2 x 3 (bxhxd)")
      end
      it "should round w x h x d" do
        expect(Work.new.whd_to_s(1.002345, 2.2323543, 3.777777)).to eq("1,0023 x 2,2324 x 3,7778 (bxhxd)")
      end
      it "should add diameter if set" do
        expect(Work.new.whd_to_s(1, 2, 3, 4)).to eq("1 x 2 x 3 (bxhxd); ⌀ 4")
      end
      it "should add diameter if set" do
        expect(Work.new.whd_to_s(1, nil, 3, 4)).to eq("1 x 3 (bxd); ⌀ 4")
      end
    end
    describe ".frame_size" do
      it "should use whd_to_s" do
        expect(Work.new(frame_width: 1, frame_height: nil, frame_depth: 3, frame_diameter: 4).frame_size).to eq("1 x 3 (bxd); ⌀ 4")
      end
    end
    describe ".to_workbook" do
      it "should be callable and return a workbook" do
        expect(Work.to_workbook.class).to eq(Workbook::Book)
      end
      it "should be work even with complex fieldset" do
        collection = collections(:collection4)
        expect(Work.to_workbook(collection.fields_to_expose(:default)).class).to eq(Workbook::Book)
      end
    end
  end
end
