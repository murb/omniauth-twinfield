require 'rails_helper'

RSpec.describe CachedApi, type: :model do
  describe  "class methods" do
    describe ".query" do
      it "should return json" do
        fake_open_url = Rails.root.to_s+"/spec/fixtures/test_json.json"
        CachedApi.find_or_create_by({query: fake_open_url})
        expect(CachedApi.query(fake_open_url)).to eq([{"a"=>2}])
        # p geoname_summaries_url
      end
    end
  end

end
