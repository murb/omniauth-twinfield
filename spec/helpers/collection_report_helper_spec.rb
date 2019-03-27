# frozen_string_literal: true

require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the TagsHelper. For example:
#
# describe TagsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe CollectionReportHelper, type: :helper do
  describe "#render_report_section" do
    before(:each) do
      @collection = collections(:collection1)
      allow(helper).to receive(:report).and_return (
        {
          :"object_format_code.keyword"=>{"m"=>{:count=>1083, :subs=>{}}, "l"=>{:count=>553, :subs=>{}}, "s"=>{:count=>357, :subs=>{}}, "xl"=>{:count=>211, :subs=>{}}, "xs"=>{:count=>132, :subs=>{}}, :missing=>{:count=>71, :subs=>{}}},
          :frame_damage_types=>{},
          :condition_work=>{{1=>"Goed (++)"}=>{:count=>2265, :subs=>{}}, {4=>"Slecht (--)"}=>{:count=>83, :subs=>{}}, {3=>"Matig (-)"}=>{:count=>38, :subs=>{}}, {2=>"Redelijk/Voldoende (+)"}=>{:count=>2, :subs=>{}}, :missing=>{:count=>19, :subs=>{}}},
          :object_creation_year=>{:missing=>{:count=>993, :subs=>{}}, [2002]=>{:count=>109, :subs=>{}}},
          :object_categories_split=>{{4=>"Grafiek"}=>{:count=>1144, :subs=>{:techniques=>{:missing=>{:count=>20, :subs=>{}}, {33=>"Zeefdruk"}=>{:count=>454, :subs=>{}}, {7=>"Ets"}=>{:count=>278, :subs=>{}}, {17=>"Lithografie"}=>{:count=>169, :subs=>{}}, {13=>"Houtsnede"}=>{:count=>126, :subs=>{}}, {16=>"Linoleumsnede"}=>{:count=>44, :subs=>{}}, {35=>"Handgekleurd"}=>{:count=>41, :subs=>{}}, {45=>"Gravure"}=>{:count=>26, :subs=>{}}, {9=>"Droge naald"}=>{:count=>16, :subs=>{}}, {91=>"Hoogdruk"}=>{:count=>12, :subs=>{}}, {158=>"Fosforprent"}=>{:count=>9, :subs=>{}}, {92=>"Diepdruk"}=>{:count=>8, :subs=>{}}, {137=>"Monotype"}=>{:count=>4, :subs=>{}}, {12=>"Gemengde techniek"}=>{:count=>3, :subs=>{}}, {162=>"Reproductie"}=>{:count=>3, :subs=>{}}, {172=>"Sjabloondruk"}=>{:count=>3, :subs=>{}}, {4=>"Blinddruk"}=>{:count=>1, :subs=>{}}, {72=>"Giclée"}=>{:count=>1, :subs=>{}}}}}},
          :market_value=>{:missing=>{:count=>2407, :subs=>{}}},
          :"location_raw.keyword"=>{"Aaaa"=>{:count=>1527, :subs=>{:"location_floor_raw.keyword"=>{:missing=>{:count=>12, :subs=>{}}, "A"=>{:count=>429, :subs=>{:"location_detail_raw.keyword"=>{"7"=>{:count=>62, :subs=>{}}, "1"=>{:count=>61, :subs=>{}}, "2"=>{:count=>57, :subs=>{}}, "3"=>{:count=>55, :subs=>{}}, "4"=>{:count=>55, :subs=>{}}, "6"=>{:count=>51, :subs=>{}}, "5"=>{:count=>46, :subs=>{}}, "8"=>{:count=>41, :subs=>{}}, "4 OF 6"=>{:count=>1, :subs=>{}}, :missing=>{:count=>0, :subs=>{}}}}}, "B"=>{:count=>293, :subs=>{:"location_detail_raw.keyword"=>{"2"=>{:count=>59, :subs=>{}}, "4"=>{:count=>54, :subs=>{}}, "1"=>{:count=>51, :subs=>{}}, "3"=>{:count=>50, :subs=>{}}, "op stelling 5"=>{:count=>42, :subs=>{}}, "5"=>{:count=>37, :subs=>{}}, :missing=>{:count=>0, :subs=>{}}}}}, "grote hal"=>{:count=>276, :subs=>{:"location_detail_raw.keyword"=>{"in doos"=>{:count=>214, :subs=>{}}, "18"=>{:count=>1, :subs=>{}}, "doos nr 20"=>{:count=>1, :subs=>{}}, :missing=>{:count=>60, :subs=>{}}}}}, "HV"=>{:count=>153, :subs=>{:"location_detail_raw.keyword"=>{:missing=>{:count=>153, :subs=>{}}}}}, "C"=>{:count=>110, :subs=>{:"location_detail_raw.keyword"=>{"2"=>{:count=>64, :subs=>{}}, "1"=>{:count=>26, :subs=>{}}, "6"=>{:count=>19, :subs=>{}}, "5"=>{:count=>1, :subs=>{}}, :missing=>{:count=>0, :subs=>{}}}}}, "verrijdbare verhuisbak"=>{:count=>104, :subs=>{:"location_detail_raw.keyword"=>{:missing=>{:count=>104, :subs=>{}}}}}, "grote hal in doos"=>{:count=>50, :subs=>{:"location_detail_raw.keyword"=>{:missing=>{:count=>50, :subs=>{}}}}}, "D"=>{:count=>48, :subs=>{:"location_detail_raw.keyword"=>{"2"=>{:count=>23, :subs=>{}}, "1"=>{:count=>9, :subs=>{}}, "3"=>{:count=>8, :subs=>{}}, "1 doos"=>{:count=>6, :subs=>{}}, :missing=>{:count=>2, :subs=>{}}}}}, "grijze bak"=>{:count=>12, :subs=>{:"location_detail_raw.keyword"=>{:missing=>{:count=>12, :subs=>{}}}}}, "achterwand"=>{:count=>8, :subs=>{:"location_detail_raw.keyword"=>{:missing=>{:count=>8, :subs=>{}}}}}, "ZIJWAND"=>{:count=>7, :subs=>{:"location_detail_raw.keyword"=>{:missing=>{:count=>7, :subs=>{}}}}}, "zijwand"=>{:count=>6, :subs=>{:"location_detail_raw.keyword"=>{:missing=>{:count=>6, :subs=>{}}}}}, "opslagloods"=>{:count=>5, :subs=>{:"location_detail_raw.keyword"=>{:missing=>{:count=>5, :subs=>{}}}}}, "restauratie"=>{:count=>4, :subs=>{:"location_detail_raw.keyword"=>{:missing=>{:count=>4, :subs=>{}}}}}, "Grote hal"=>{:count=>3, :subs=>{:"location_detail_raw.keyword"=>{:missing=>{:count=>3, :subs=>{}}}}}, "grote hal in aparte bakken"=>{:count=>2, :subs=>{:"location_detail_raw.keyword"=>{:missing=>{:count=>2, :subs=>{}}}}}, "3"=>{:count=>1, :subs=>{:"location_detail_raw.keyword"=>{:missing=>{:count=>1, :subs=>{}}}}}, "D3"=>{:count=>1, :subs=>{:"location_detail_raw.keyword"=>{:missing=>{:count=>1, :subs=>{}}}}}, "HV (zou nog in HdP zijn?)"=>{:count=>1, :subs=>{:"location_detail_raw.keyword"=>{:missing=>{:count=>1, :subs=>{}}}}}, "naast A"=>{:count=>1, :subs=>{:"location_detail_raw.keyword"=>{"8"=>{:count=>1, :subs=>{}}, :missing=>{:count=>0, :subs=>{}}}}}, "verrijdbare verhuisbak met oningelijst werk"=>{:count=>1, :subs=>{:"location_detail_raw.keyword"=>{:missing=>{:count=>1, :subs=>{}}}}}}}}, "M"=>{:count=>330, :subs=>{:"location_floor_raw.keyword"=>{:missing=>{:count=>0, :subs=>{}}, "2"=>{:count=>78, :subs=>{:"location_detail_raw.keyword"=>{"2"=>{:count=>12, :subs=>{}}, "30"=>{:count=>6, :subs=>{}}, "99"=>{:count=>6, :subs=>{}}, "56"=>{:count=>5, :subs=>{}}, "62"=>{:count=>5, :subs=>{}}, "16"=>{:count=>4, :subs=>{}}, "46"=>{:count=>4, :subs=>{}}, "13"=>{:count=>3, :subs=>{}}, "24"=>{:count=>3, :subs=>{}}, "5"=>{:count=>3, :subs=>{}}, "12"=>{:count=>2, :subs=>{}}, "14"=>{:count=>2, :subs=>{}}, "20"=>{:count=>2, :subs=>{}}, "25"=>{:count=>2, :subs=>{}}, "42"=>{:count=>2, :subs=>{}}, "54"=>{:count=>2, :subs=>{}}, "76"=>{:count=>2, :subs=>{}}, "78"=>{:count=>2, :subs=>{}}, "11"=>{:count=>1, :subs=>{}}, "15A"=>{:count=>1, :subs=>{}}, "17"=>{:count=>1, :subs=>{}}, "19"=>{:count=>1, :subs=>{}}, "21"=>{:count=>1, :subs=>{}}, "23"=>{:count=>1, :subs=>{}}, "26"=>{:count=>1, :subs=>{}}, "40"=>{:count=>1, :subs=>{}}, "52"=>{:count=>1, :subs=>{}}, "7"=>{:count=>1, :subs=>{}}, "80"=>{:count=>1, :subs=>{}}, :missing=>{:count=>0, :subs=>{}}}}}, "0"=>{:count=>68, :subs=>{:"location_detail_raw.keyword"=>{"99"=>{:count=>36, :subs=>{}}, "26"=>{:count=>5, :subs=>{}}, "56"=>{:count=>4, :subs=>{}}, "70"=>{:count=>4, :subs=>{}}, "48"=>{:count=>3, :subs=>{}}, "40"=>{:count=>2, :subs=>{}}, "42"=>{:count=>2, :subs=>{}}, "46"=>{:count=>2, :subs=>{}}, "82"=>{:count=>2, :subs=>{}}, "22"=>{:count=>1, :subs=>{}}, "36"=>{:count=>1, :subs=>{}}, "38"=>{:count=>1, :subs=>{}}, "58"=>{:count=>1, :subs=>{}}, "64"=>{:count=>1, :subs=>{}}, "78"=>{:count=>1, :subs=>{}}, "80"=>{:count=>1, :subs=>{}}, "entree"=>{:count=>1, :subs=>{}}, :missing=>{:count=>0, :subs=>{}}}}}, "3"=>{:count=>68, :subs=>{:"location_detail_raw.keyword"=>{"1"=>{:count=>8, :subs=>{}}, "60"=>{:count=>7, :subs=>{}}, "11"=>{:count=>6, :subs=>{}}, "56"=>{:count=>6, :subs=>{}}, "28"=>{:count=>5, :subs=>{}}, "12"=>{:count=>4, :subs=>{}}, "44"=>{:count=>4, :subs=>{}}, "20"=>{:count=>3, :subs=>{}}, "5"=>{:count=>3, :subs=>{}}, "16"=>{:count=>2, :subs=>{}}, "17"=>{:count=>2, :subs=>{}}, "21"=>{:count=>2, :subs=>{}}, "40"=>{:count=>2, :subs=>{}}, "52"=>{:count=>2, :subs=>{}}, "99"=>{:count=>2, :subs=>{}}, "10"=>{:count=>1, :subs=>{}}, "18"=>{:count=>1, :subs=>{}}, "24"=>{:count=>1, :subs=>{}}, "25"=>{:count=>1, :subs=>{}}, "48"=>{:count=>1, :subs=>{}}, "54"=>{:count=>1, :subs=>{}}, "6"=>{:count=>1, :subs=>{}}, "7"=>{:count=>1, :subs=>{}}, "9"=>{:count=>1, :subs=>{}}, "belplek"=>{:count=>1, :subs=>{}}, :missing=>{:count=>0, :subs=>{}}}}}, "1"=>{:count=>61, :subs=>{:"location_detail_raw.keyword"=>{"99"=>{:count=>8, :subs=>{}}, "19"=>{:count=>7, :subs=>{}}, "44"=>{:count=>4, :subs=>{}}, "52"=>{:count=>4, :subs=>{}}, "29"=>{:count=>3, :subs=>{}}, "9"=>{:count=>3, :subs=>{}}, "12"=>{:count=>2, :subs=>{}}, "20"=>{:count=>2, :subs=>{}}, "22"=>{:count=>2, :subs=>{}}, "27"=>{:count=>2, :subs=>{}}, "28"=>{:count=>2, :subs=>{}}, "34"=>{:count=>2, :subs=>{}}, "48"=>{:count=>2, :subs=>{}}, "8"=>{:count=>2, :subs=>{}}, "98"=>{:count=>2, :subs=>{}}, "11"=>{:count=>1, :subs=>{}}, "14"=>{:count=>1, :subs=>{}}, "16"=>{:count=>1, :subs=>{}}, "18"=>{:count=>1, :subs=>{}}, "23"=>{:count=>1, :subs=>{}}, "25"=>{:count=>1, :subs=>{}}, "26"=>{:count=>1, :subs=>{}}, "31"=>{:count=>1, :subs=>{}}, "36"=>{:count=>1, :subs=>{}}, "42"=>{:count=>1, :subs=>{}}, "50"=>{:count=>1, :subs=>{}}, "6B"=>{:count=>1, :subs=>{}}, "6a"=>{:count=>1, :subs=>{}}, "70"=>{:count=>1, :subs=>{}}, :missing=>{:count=>0, :subs=>{}}}}}, "4"=>{:count=>54, :subs=>{:"location_detail_raw.keyword"=>{"11"=>{:count=>8, :subs=>{}}, "6"=>{:count=>7, :subs=>{}}, "24"=>{:count=>5, :subs=>{}}, "16"=>{:count=>4, :subs=>{}}, "30"=>{:count=>4, :subs=>{}}, "1"=>{:count=>3, :subs=>{}}, "2"=>{:count=>3, :subs=>{}}, "20"=>{:count=>3, :subs=>{}}, "22"=>{:count=>3, :subs=>{}}, "28"=>{:count=>3, :subs=>{}}, "5"=>{:count=>3, :subs=>{}}, "99"=>{:count=>3, :subs=>{}}, "8"=>{:count=>2, :subs=>{}}, "9"=>{:count=>2, :subs=>{}}, "14"=>{:count=>1, :subs=>{}}, :missing=>{:count=>0, :subs=>{}}}}}, "04"=>{:count=>1, :subs=>{:"location_detail_raw.keyword"=>{"22"=>{:count=>1, :subs=>{}}, :missing=>{:count=>0, :subs=>{}}}}}}}}, "A"=>{:count=>309, :subs=>{:"location_floor_raw.keyword"=>{:missing=>{:count=>0, :subs=>{}}, "4"=>{:count=>65, :subs=>{:"location_detail_raw.keyword"=>{"99"=>{:count=>10, :subs=>{}}, "3"=>{:count=>7, :subs=>{}}, "1"=>{:count=>4, :subs=>{}}, "17"=>{:count=>4, :subs=>{}}, "19"=>{:count=>3, :subs=>{}}, "26"=>{:count=>3, :subs=>{}}, "30"=>{:count=>3, :subs=>{}}, "32"=>{:count=>3, :subs=>{}}, "6"=>{:count=>3, :subs=>{}}, "9"=>{:count=>3, :subs=>{}}, "12"=>{:count=>2, :subs=>{}}, "15"=>{:count=>2, :subs=>{}}, "24"=>{:count=>2, :subs=>{}}, "25"=>{:count=>2, :subs=>{}}, "33"=>{:count=>2, :subs=>{}}, "5"=>{:count=>2, :subs=>{}}, "11"=>{:count=>1, :subs=>{}}, "14"=>{:count=>1, :subs=>{}}, "2"=>{:count=>1, :subs=>{}}, "20"=>{:count=>1, :subs=>{}}, "21"=>{:count=>1, :subs=>{}}, "22"=>{:count=>1, :subs=>{}}, "28"=>{:count=>1, :subs=>{}}, "29"=>{:count=>1, :subs=>{}}, "7"=>{:count=>1, :subs=>{}}, "8"=>{:count=>1, :subs=>{}}, :missing=>{:count=>0, :subs=>{}}}}}, "1"=>{:count=>56, :subs=>{:"location_detail_raw.keyword"=>{"99"=>{:count=>11, :subs=>{}}, "26"=>{:count=>6, :subs=>{}}, "31"=>{:count=>5, :subs=>{}}, "11"=>{:count=>4, :subs=>{}}, "13"=>{:count=>3, :subs=>{}}, "2"=>{:count=>3, :subs=>{}}, "1"=>{:count=>2, :subs=>{}}, "15"=>{:count=>2, :subs=>{}}, "19"=>{:count=>2, :subs=>{}}, "28"=>{:count=>2, :subs=>{}}, "3"=>{:count=>2, :subs=>{}}, "30A"=>{:count=>2, :subs=>{}}, "6"=>{:count=>2, :subs=>{}}, "9"=>{:count=>2, :subs=>{}}, "10"=>{:count=>1, :subs=>{}}, "16"=>{:count=>1, :subs=>{}}, "24"=>{:count=>1, :subs=>{}}, "30B"=>{:count=>1, :subs=>{}}, "33B"=>{:count=>1, :subs=>{}}, "5"=>{:count=>1, :subs=>{}}, "7"=>{:count=>1, :subs=>{}}, "8"=>{:count=>1, :subs=>{}}, :missing=>{:count=>0, :subs=>{}}}}}, "2"=>{:count=>56, :subs=>{:"location_detail_raw.keyword"=>{"99"=>{:count=>6, :subs=>{}}, "17"=>{:count=>4, :subs=>{}}, "28"=>{:count=>4, :subs=>{}}, "15"=>{:count=>3, :subs=>{}}, "30"=>{:count=>3, :subs=>{}}, "33"=>{:count=>3, :subs=>{}}, "1"=>{:count=>2, :subs=>{}}, "11"=>{:count=>2, :subs=>{}}, "14"=>{:count=>2, :subs=>{}}, "19"=>{:count=>2, :subs=>{}}, "20"=>{:count=>2, :subs=>{}}, "22"=>{:count=>2, :subs=>{}}, "24"=>{:count=>2, :subs=>{}}, "25"=>{:count=>2, :subs=>{}}, "27"=>{:count=>2, :subs=>{}}, "3"=>{:count=>2, :subs=>{}}, "32"=>{:count=>2, :subs=>{}}, "4"=>{:count=>2, :subs=>{}}, "5"=>{:count=>2, :subs=>{}}, "10"=>{:count=>1, :subs=>{}}, "21"=>{:count=>1, :subs=>{}}, "23"=>{:count=>1, :subs=>{}}, "6"=>{:count=>1, :subs=>{}}, "7"=>{:count=>1, :subs=>{}}, "8"=>{:count=>1, :subs=>{}}, "9"=>{:count=>1, :subs=>{}}, :missing=>{:count=>0, :subs=>{}}}}}, "3"=>{:count=>53, :subs=>{:"location_detail_raw.keyword"=>{"99"=>{:count=>10, :subs=>{}}, "2"=>{:count=>4, :subs=>{}}, "23"=>{:count=>4, :subs=>{}}, "30"=>{:count=>4, :subs=>{}}, "27"=>{:count=>3, :subs=>{}}, "33"=>{:count=>3, :subs=>{}}, "1"=>{:count=>2, :subs=>{}}, "14"=>{:count=>2, :subs=>{}}, "19"=>{:count=>2, :subs=>{}}, "22"=>{:count=>2, :subs=>{}}, "24"=>{:count=>2, :subs=>{}}, "25"=>{:count=>2, :subs=>{}}, "28"=>{:count=>2, :subs=>{}}, "3"=>{:count=>2, :subs=>{}}, "5"=>{:count=>2, :subs=>{}}, "7"=>{:count=>2, :subs=>{}}, "10"=>{:count=>1, :subs=>{}}, "17"=>{:count=>1, :subs=>{}}, "21"=>{:count=>1, :subs=>{}}, "4"=>{:count=>1, :subs=>{}}, "8"=>{:count=>1, :subs=>{}}, :missing=>{:count=>0, :subs=>{}}}}}, "0"=>{:count=>40, :subs=>{:"location_detail_raw.keyword"=>{"99"=>{:count=>9, :subs=>{}}, "10"=>{:count=>4, :subs=>{}}, "19"=>{:count=>3, :subs=>{}}, "4"=>{:count=>3, :subs=>{}}, "15"=>{:count=>2, :subs=>{}}, "25"=>{:count=>2, :subs=>{}}, "3"=>{:count=>2, :subs=>{}}, "30"=>{:count=>2, :subs=>{}}, "8"=>{:count=>2, :subs=>{}}, "9"=>{:count=>2, :subs=>{}}, "1"=>{:count=>1, :subs=>{}}, "12"=>{:count=>1, :subs=>{}}, "13"=>{:count=>1, :subs=>{}}, "24"=>{:count=>1, :subs=>{}}, "28"=>{:count=>1, :subs=>{}}, "29"=>{:count=>1, :subs=>{}}, "32"=>{:count=>1, :subs=>{}}, "33"=>{:count=>1, :subs=>{}}, "34"=>{:count=>1, :subs=>{}}, :missing=>{:count=>0, :subs=>{}}}}}, "5"=>{:count=>31, :subs=>{:"location_detail_raw.keyword"=>{"3"=>{:count=>5, :subs=>{}}, "11"=>{:count=>4, :subs=>{}}, "7"=>{:count=>4, :subs=>{}}, "99"=>{:count=>4, :subs=>{}}, "13"=>{:count=>3, :subs=>{}}, "10"=>{:count=>2, :subs=>{}}, "15"=>{:count=>2, :subs=>{}}, "19"=>{:count=>2, :subs=>{}}, "9"=>{:count=>2, :subs=>{}}, "1"=>{:count=>1, :subs=>{}}, "2"=>{:count=>1, :subs=>{}}, "6"=>{:count=>1, :subs=>{}}, :missing=>{:count=>0, :subs=>{}}}}}, "7"=>{:count=>8, :subs=>{:"location_detail_raw.keyword"=>{:missing=>{:count=>8, :subs=>{}}}}}}}}, "B"=>{:count=>149, :subs=>{:"location_floor_raw.keyword"=>{:missing=>{:count=>0, :subs=>{}}, "1"=>{:count=>35, :subs=>{:"location_detail_raw.keyword"=>{"99"=>{:count=>19, :subs=>{}}, "12"=>{:count=>3, :subs=>{}}, "14"=>{:count=>3, :subs=>{}}, "1"=>{:count=>1, :subs=>{}}, "11"=>{:count=>1, :subs=>{}}, "13"=>{:count=>1, :subs=>{}}, "3"=>{:count=>1, :subs=>{}}, "31C"=>{:count=>1, :subs=>{}}, "4"=>{:count=>1, :subs=>{}}, "5"=>{:count=>1, :subs=>{}}, "6"=>{:count=>1, :subs=>{}}, "7"=>{:count=>1, :subs=>{}}, "8"=>{:count=>1, :subs=>{}}, :missing=>{:count=>0, :subs=>{}}}}}, "3"=>{:count=>29, :subs=>{:"location_detail_raw.keyword"=>{"99"=>{:count=>5, :subs=>{}}, "10"=>{:count=>4, :subs=>{}}, "7"=>{:count=>4, :subs=>{}}, "21"=>{:count=>3, :subs=>{}}, "3"=>{:count=>3, :subs=>{}}, "19"=>{:count=>2, :subs=>{}}, "1"=>{:count=>1, :subs=>{}}, "12"=>{:count=>1, :subs=>{}}, "16A"=>{:count=>1, :subs=>{}}, "16B"=>{:count=>1, :subs=>{}}, "20"=>{:count=>1, :subs=>{}}, "6A"=>{:count=>1, :subs=>{}}, "6B"=>{:count=>1, :subs=>{}}, "9"=>{:count=>1, :subs=>{}}, :missing=>{:count=>0, :subs=>{}}}}}, "0"=>{:count=>25, :subs=>{:"location_detail_raw.keyword"=>{"23"=>{:count=>7, :subs=>{}}, "99"=>{:count=>5, :subs=>{}}, "3A"=>{:count=>2, :subs=>{}}, "4"=>{:count=>2, :subs=>{}}, "7"=>{:count=>2, :subs=>{}}, "9"=>{:count=>2, :subs=>{}}, "1"=>{:count=>1, :subs=>{}}, "3B"=>{:count=>1, :subs=>{}}, "5"=>{:count=>1, :subs=>{}}, "6"=>{:count=>1, :subs=>{}}, "8"=>{:count=>1, :subs=>{}}, :missing=>{:count=>0, :subs=>{}}}}}, "4"=>{:count=>25, :subs=>{:"location_detail_raw.keyword"=>{"2"=>{:count=>6, :subs=>{}}, "18"=>{:count=>3, :subs=>{}}, "12"=>{:count=>2, :subs=>{}}, "14"=>{:count=>2, :subs=>{}}, "16"=>{:count=>2, :subs=>{}}, "1A"=>{:count=>2, :subs=>{}}, "21"=>{:count=>2, :subs=>{}}, "10"=>{:count=>1, :subs=>{}}, "11"=>{:count=>1, :subs=>{}}, "1B"=>{:count=>1, :subs=>{}}, "6A"=>{:count=>1, :subs=>{}}, "6B"=>{:count=>1, :subs=>{}}, "9"=>{:count=>1, :subs=>{}}, :missing=>{:count=>0, :subs=>{}}}}}, "2"=>{:count=>21, :subs=>{:"location_detail_raw.keyword"=>{"99"=>{:count=>6, :subs=>{}}, "10"=>{:count=>4, :subs=>{}}, "12"=>{:count=>3, :subs=>{}}, "1"=>{:count=>2, :subs=>{}}, "18"=>{:count=>2, :subs=>{}}, "2"=>{:count=>2, :subs=>{}}, "20"=>{:count=>1, :subs=>{}}, "9"=>{:count=>1, :subs=>{}}, :missing=>{:count=>0, :subs=>{}}}}}, "00"=>{:count=>14, :subs=>{:"location_detail_raw.keyword"=>{"23 Bedrijfsrestaurant"=>{:count=>14, :subs=>{}}, :missing=>{:count=>0, :subs=>{}}}}}}}}, "Lex Lijsten"=>{:count=>36, :subs=>{:"location_floor_raw.keyword"=>{:missing=>{:count=>36, :subs=>{}}}}}, "Deventer"=>{:count=>20, :subs=>{:"location_floor_raw.keyword"=>{:missing=>{:count=>20, :subs=>{}}}}}, "Restaurant"=>{:count=>17, :subs=>{:"location_floor_raw.keyword"=>{:missing=>{:count=>17, :subs=>{}}}}}, "Zoek"=>{:count=>7, :subs=>{:"location_floor_raw.keyword"=>{:missing=>{:count=>7, :subs=>{}}}}}, "Z'huis Rijnstate Arnhem"=>{:count=>6, :subs=>{:"location_floor_raw.keyword"=>{:missing=>{:count=>6, :subs=>{}}}}}, "H"=>{:count=>2, :subs=>{:"location_floor_raw.keyword"=>{:missing=>{:count=>0, :subs=>{}}, "0"=>{:count=>1, :subs=>{:"location_detail_raw.keyword"=>{"AJ"=>{:count=>1, :subs=>{}}, :missing=>{:count=>0, :subs=>{}}}}}, "1"=>{:count=>1, :subs=>{:"location_detail_raw.keyword"=>{"64"=>{:count=>1, :subs=>{}}, :missing=>{:count=>0, :subs=>{}}}}}}}}, "Loo"=>{:count=>1, :subs=>{:"location_floor_raw.keyword"=>{:missing=>{:count=>1, :subs=>{}}}}}, "M 3.01"=>{:count=>1, :subs=>{:"location_floor_raw.keyword"=>{:missing=>{:count=>0, :subs=>{}}, "A"=>{:count=>1, :subs=>{:"location_detail_raw.keyword"=>{"5"=>{:count=>1, :subs=>{}}, :missing=>{:count=>0, :subs=>{}}}}}}}}, "Vlotweg C6"=>{:count=>1, :subs=>{:"location_floor_raw.keyword"=>{:missing=>{:count=>0, :subs=>{}}, "0"=>{:count=>1, :subs=>{:"location_detail_raw.keyword"=>{"23"=>{:count=>1, :subs=>{}}, :missing=>{:count=>0, :subs=>{}}}}}}}}, "en lijst"=>{:count=>1, :subs=>{:"location_floor_raw.keyword"=>{:missing=>{:count=>1, :subs=>{}}}}}, :missing=>{:count=>0, :subs=>{}}}, :image_rights=>{:missing=>{:count=>0, :subs=>{}}, [0]=>{:count=>2344, :subs=>{:key_as_string=>{}}}, [1]=>{:count=>63, :subs=>{:key_as_string=>{}}}}, :publish=>{:missing=>{:count=>0, :subs=>{}}, [1]=>{:count=>1930, :subs=>{:key_as_string=>{}}}, [0]=>{:count=>477, :subs=>{:key_as_string=>{}}}}, :frame_type=>{{1=>"Hout"}=>{:count=>1197, :subs=>{}}, {8=>"Aluminium"}=>{:count=>304, :subs=>{}}, {9=>"Aluminium wit"}=>{:count=>47, :subs=>{}}, {13=>"Aluminium zwart"}=>{:count=>28, :subs=>{}}, {4=>"Hout zwart"}=>{:count=>26, :subs=>{}}, {12=>"Aluminium blauw"}=>{:count=>20, :subs=>{}}, {14=>"Aluminium groen"}=>{:count=>18, :subs=>{}}, {11=>"Aluminium paars"}=>{:count=>10, :subs=>{}}, {2=>"Hout goud"}=>{:count=>6, :subs=>{}}, {7=>"Kunststof"}=>{:count=>6, :subs=>{}}, {15=>"Aluminium rood"}=>{:count=>6, :subs=>{}}, {16=>"Aluminium goud"}=>{:count=>6, :subs=>{}}, {20=>"Staal"}=>{:count=>5, :subs=>{}}, {5=>"Hout wit"}=>{:count=>3, :subs=>{}}, {17=>"Aluminium brons"}=>{:count=>3, :subs=>{}}, {19=>"Metaal"}=>{:count=>3, :subs=>{}}, {10=>"Aluminium paars/blauw"}=>{:count=>2, :subs=>{}}, {21=>"Baklijst"}=>{:count=>2, :subs=>{}}, {3=>"Hout zilver"}=>{:count=>1, :subs=>{}}, {6=>"Hout groen"}=>{:count=>1, :subs=>{}}, {18=>"Multiplex"}=>{:count=>1, :subs=>{}}}, :replacement_value=>{:missing=>{:count=>2407, :subs=>{}}}, :"abstract_or_figurative.keyword"=>{:missing=>{:count=>2407, :subs=>{}}}, :object_categories=>{{4=>"Grafiek"}=>{:count=>1144, :subs=>{:techniques=>{:missing=>{:count=>0, :subs=>{}}, {33=>"Zeefdruk"}=>{:count=>441, :subs=>{}}, {7=>"Ets"}=>{:count=>221, :subs=>{}}, {17=>"Lithografie"}=>{:count=>169, :subs=>{}}, {13=>"Houtsnede"}=>{:count=>126, :subs=>{}}, {16=>"Linoleumsnede"}=>{:count=>44, :subs=>{}}, {7=>"Ets", 35=>"Handgekleurd"}=>{:count=>40, :subs=>{}}, {45=>"Gravure"}=>{:count=>22, :subs=>{}}, {}=>{:count=>20, :subs=>{}}, {7=>"Ets", 9=>"Droge naald"}=>{:count=>16, :subs=>{}}, {91=>"Hoogdruk"}=>{:count=>11, :subs=>{}}, {33=>"Zeefdruk", 158=>"Fosforprent"}=>{:count=>9, :subs=>{}}, {92=>"Diepdruk"}=>{:count=>7, :subs=>{}}, {137=>"Monotype"}=>{:count=>3, :subs=>{}}, {172=>"Sjabloondruk"}=>{:count=>3, :subs=>{}}, {45=>"Gravure", 162=>"Reproductie"}=>{:count=>3, :subs=>{}}, {12=>"Gemengde techniek", 33=>"Zeefdruk"}=>{:count=>2, :subs=>{}}, {12=>"Gemengde techniek"}=>{:count=>1, :subs=>{}}, {33=>"Zeefdruk", 137=>"Monotype"}=>{:count=>1, :subs=>{}}, {33=>"Zeefdruk", 91=>"Hoogdruk"}=>{:count=>1, :subs=>{}}, {35=>"Handgekleurd", 45=>"Gravure"}=>{:count=>1, :subs=>{}}, {4=>"Blinddruk"}=>{:count=>1, :subs=>{}}, {7=>"Ets", 92=>"Diepdruk"}=>{:count=>1, :subs=>{}}, {72=>"Giclée"}=>{:count=>1, :subs=>{}}}}}, {2=>"Fotografie"}=>{:count=>472, :subs=>{:techniques=>{:missing=>{:count=>0, :subs=>{}}, {}=>{:count=>448, :subs=>{}}, {42=>"Kleurenfoto"}=>{:count=>19, :subs=>{}}, {40=>"Zwart-witfoto"}=>{:count=>4, :subs=>{}}, {89=>"Cibachrome"}=>{:count=>1, :subs=>{}}}}}, {5=>"Schilderkunst"}=>{:count=>282, :subs=>{:techniques=>{:missing=>{:count=>0, :subs=>{}}, {20=>"Olieverf"}=>{:count=>157, :subs=>{}}, {1=>"Acrylverf"}=>{:count=>34, :subs=>{}}, {1=>"Acrylverf", 20=>"Olieverf"}=>{:count=>31, :subs=>{}}, {3=>"Aquarel", 11=>"Gouache"}=>{:count=>16, :subs=>{}}, {12=>"Gemengde techniek"}=>{:count=>12, :subs=>{}}, {}=>{:count=>6, :subs=>{}}, {30=>"Tempera"}=>{:count=>6, :subs=>{}}, {1=>"Acrylverf", 12=>"Gemengde techniek"}=>{:count=>3, :subs=>{}}, {1=>"Acrylverf", 3=>"Aquarel", 11=>"Gouache"}=>{:count=>3, :subs=>{}}, {11=>"Gouache", 12=>"Gemengde techniek"}=>{:count=>3, :subs=>{}}, {11=>"Gouache"}=>{:count=>2, :subs=>{}}, {12=>"Gemengde techniek", 160=>"Teer"}=>{:count=>2, :subs=>{}}, {1=>"Acrylverf", 24=>"Houtskool"}=>{:count=>1, :subs=>{}}, {12=>"Gemengde techniek", 20=>"Olieverf"}=>{:count=>1, :subs=>{}}, {12=>"Gemengde techniek", 30=>"Tempera"}=>{:count=>1, :subs=>{}}, {3=>"Aquarel", 11=>"Gouache", 28=>"Potlood"}=>{:count=>1, :subs=>{}}, {3=>"Aquarel", 12=>"Gemengde techniek"}=>{:count=>1, :subs=>{}}, {6=>"Collage", 12=>"Gemengde techniek"}=>{:count=>1, :subs=>{}}, {6=>"Collage", 20=>"Olieverf"}=>{:count=>1, :subs=>{}}}}}, {}=>{:count=>223, :subs=>{:techniques=>{:missing=>{:count=>0, :subs=>{}}, {3=>"Aquarel", 11=>"Gouache"}=>{:count=>73, :subs=>{}}, {23=>"Tekening", 25=>"Krijt", 28=>"Potlood"}=>{:count=>39, :subs=>{}}, {12=>"Gemengde techniek"}=>{:count=>20, :subs=>{}}, {12=>"Gemengde techniek", 33=>"Zeefdruk"}=>{:count=>12, :subs=>{}}, {}=>{:count=>11, :subs=>{}}, {23=>"Tekening", 24=>"Houtskool", 25=>"Krijt", 28=>"Potlood"}=>{:count=>8, :subs=>{}}, {6=>"Collage", 12=>"Gemengde techniek"}=>{:count=>6, :subs=>{}}, {23=>"Tekening", 25=>"Krijt", 26=>"Pastel", 28=>"Potlood", 93=>"Grafiet"}=>{:count=>5, :subs=>{}}, {25=>"Krijt", 28=>"Potlood"}=>{:count=>5, :subs=>{}}, {34=>"Hout"}=>{:count=>5, :subs=>{}}, {12=>"Gemengde techniek", 36=>"Inkt"}=>{:count=>3, :subs=>{}}, {23=>"Tekening"}=>{:count=>3, :subs=>{}}, {11=>"Gouache", 12=>"Gemengde techniek", 23=>"Tekening"}=>{:count=>2, :subs=>{}}, {12=>"Gemengde techniek", 137=>"Monotype"}=>{:count=>2, :subs=>{}}, {12=>"Gemengde techniek", 174=>"Inktjetprint"}=>{:count=>2, :subs=>{}}, {168=>"Lak"}=>{:count=>2, :subs=>{}}, {25=>"Krijt", 28=>"Potlood", 163=>"Wasco"}=>{:count=>2, :subs=>{}}, {6=>"Collage"}=>{:count=>2, :subs=>{}}, {6=>"Collage", 126=>"Papier"}=>{:count=>2, :subs=>{}}, {1=>"Acrylverf", 20=>"Olieverf"}=>{:count=>1, :subs=>{}}, {11=>"Gouache", 12=>"Gemengde techniek"}=>{:count=>1, :subs=>{}}, {12=>"Gemengde techniek", 162=>"Reproductie"}=>{:count=>1, :subs=>{}}, {12=>"Gemengde techniek", 46=>"Gips"}=>{:count=>1, :subs=>{}}, {12=>"Gemengde techniek", 57=>"Lakverf"}=>{:count=>1, :subs=>{}}, {162=>"Reproductie"}=>{:count=>1, :subs=>{}}, {17=>"Lithografie", 31=>"Textiel"}=>{:count=>1, :subs=>{}}, {173=>"Sproeidruk"}=>{:count=>1, :subs=>{}}, {20=>"Olieverf"}=>{:count=>1, :subs=>{}}, {20=>"Olieverf", 57=>"Lakverf"}=>{:count=>1, :subs=>{}}, {23=>"Tekening", 25=>"Krijt", 28=>"Potlood", 163=>"Wasco"}=>{:count=>1, :subs=>{}}, {23=>"Tekening", 27=>"Pen"}=>{:count=>1, :subs=>{}}, {23=>"Tekening", 36=>"Inkt"}=>{:count=>1, :subs=>{}}, {24=>"Houtskool", 25=>"Krijt", 28=>"Potlood"}=>{:count=>1, :subs=>{}}, {3=>"Aquarel", 12=>"Gemengde techniek", 20=>"Olieverf", 28=>"Potlood"}=>{:count=>1, :subs=>{}}, {3=>"Aquarel", 20=>"Olieverf", 28=>"Potlood"}=>{:count=>1, :subs=>{}}, {3=>"Aquarel", 36=>"Inkt"}=>{:count=>1, :subs=>{}}, {33=>"Zeefdruk"}=>{:count=>1, :subs=>{}}, {7=>"Ets", 23=>"Tekening", 33=>"Zeefdruk"}=>{:count=>1, :subs=>{}}}}}, {9=>"Vormgeving"}=>{:count=>170, :subs=>{:techniques=>{:missing=>{:count=>0, :subs=>{}}, {15=>"Keramiek"}=>{:count=>106, :subs=>{}}, {33=>"Zeefdruk"}=>{:count=>24, :subs=>{}}, {}=>{:count=>9, :subs=>{}}, {34=>"Hout"}=>{:count=>9, :subs=>{}}, {31=>"Textiel"}=>{:count=>8, :subs=>{}}, {43=>"Emaille"}=>{:count=>6, :subs=>{}}, {10=>"Glas"}=>{:count=>3, :subs=>{}}, {151=>"Tin"}=>{:count=>2, :subs=>{}}, {164=>"Gietijzer"}=>{:count=>1, :subs=>{}}, {5=>"Brons"}=>{:count=>1, :subs=>{}}, {75=>"Porselein"}=>{:count=>1, :subs=>{}}}}}, {8=>"Uniek werk op papier"}=>{:count=>69, :subs=>{:techniques=>{:missing=>{:count=>0, :subs=>{}}, {1=>"Acrylverf"}=>{:count=>9, :subs=>{}}, {1=>"Acrylverf", 12=>"Gemengde techniek"}=>{:count=>7, :subs=>{}}, {23=>"Tekening", 25=>"Krijt", 28=>"Potlood"}=>{:count=>7, :subs=>{}}, {23=>"Tekening"}=>{:count=>6, :subs=>{}}, {23=>"Tekening", 28=>"Potlood", 84=>"Kleurpotlood"}=>{:count=>6, :subs=>{}}, {1=>"Acrylverf", 20=>"Olieverf"}=>{:count=>5, :subs=>{}}, {20=>"Olieverf"}=>{:count=>5, :subs=>{}}, {23=>"Tekening", 24=>"Houtskool"}=>{:count=>4, :subs=>{}}, {23=>"Tekening", 25=>"Krijt", 28=>"Potlood", 36=>"Inkt"}=>{:count=>3, :subs=>{}}, {1=>"Acrylverf", 3=>"Aquarel", 11=>"Gouache"}=>{:count=>2, :subs=>{}}, {23=>"Tekening", 25=>"Krijt", 28=>"Potlood", 84=>"Kleurpotlood"}=>{:count=>2, :subs=>{}}, {23=>"Tekening", 38=>"Zand"}=>{:count=>2, :subs=>{}}, {6=>"Collage", 12=>"Gemengde techniek"}=>{:count=>2, :subs=>{}}, {1=>"Acrylverf", 12=>"Gemengde techniek", 36=>"Inkt"}=>{:count=>1, :subs=>{}}, {12=>"Gemengde techniek", 23=>"Tekening"}=>{:count=>1, :subs=>{}}, {12=>"Gemengde techniek", 26=>"Pastel", 28=>"Potlood", 93=>"Grafiet"}=>{:count=>1, :subs=>{}}, {23=>"Tekening", 24=>"Houtskool", 26=>"Pastel", 84=>"Kleurpotlood", 98=>"Conté"}=>{:count=>1, :subs=>{}}, {23=>"Tekening", 28=>"Potlood"}=>{:count=>1, :subs=>{}}, {23=>"Tekening", 36=>"Inkt"}=>{:count=>1, :subs=>{}}, {36=>"Inkt"}=>{:count=>1, :subs=>{}}, {36=>"Inkt", 39=>"Oost-Indische"}=>{:count=>1, :subs=>{}}, {6=>"Collage", 12=>"Gemengde techniek", 27=>"Pen", 28=>"Potlood"}=>{:count=>1, :subs=>{}}}}}, {6=>"Sculptuur (binnen)"}=>{:count=>47, :subs=>{:techniques=>{:missing=>{:count=>0, :subs=>{}}, {5=>"Brons", 52=>"Metaal"}=>{:count=>9, :subs=>{}}, {15=>"Keramiek"}=>{:count=>8, :subs=>{}}, {5=>"Brons", 161=>"Plastiek"}=>{:count=>6, :subs=>{}}, {34=>"Hout"}=>{:count=>5, :subs=>{}}, {}=>{:count=>2, :subs=>{}}, {5=>"Brons"}=>{:count=>2, :subs=>{}}, {53=>"Messing", 175=>"IJzerglimmerverf"}=>{:count=>2, :subs=>{}}, {65=>"Kunststof"}=>{:count=>2, :subs=>{}}, {108=>"Marmer"}=>{:count=>1, :subs=>{}}, {12=>"Gemengde techniek", 31=>"Textiel"}=>{:count=>1, :subs=>{}}, {12=>"Gemengde techniek", 34=>"Hout", 130=>"IJzer"}=>{:count=>1, :subs=>{}}, {19=>"Object", 34=>"Hout"}=>{:count=>1, :subs=>{}}, {31=>"Textiel"}=>{:count=>1, :subs=>{}}, {48=>"Steen"}=>{:count=>1, :subs=>{}}, {48=>"Steen", 108=>"Marmer"}=>{:count=>1, :subs=>{}}, {52=>"Metaal"}=>{:count=>1, :subs=>{}}, {52=>"Metaal", 130=>"IJzer"}=>{:count=>1, :subs=>{}}, {52=>"Metaal", 55=>"Staal"}=>{:count=>1, :subs=>{}}, {55=>"Staal"}=>{:count=>1, :subs=>{}}}}}, :missing=>{:count=>0, :subs=>{}}},
          :style=>{}, :subset=>{}

        }
      )
    end
    it "should render a empt report when no values are given" do
      expect(helper.render_report_section([:frame_damage_types])).to eq("")
    end
    it "should render a simple report (with missing)" do
      expect(helper.render_report_section([:condition_work])).to eq("<table><tr class=\"section condition_work span-7\"><th colspan=\"8\">Conditie beeld</th></tr>
<tr class=\"content span-6\"><td colspan=\"6\"><a href=\"/collections/#{@collection.id}/works?filter%5Bcondition_work_id%5D%5B%5D=1\">Goed (++)</a></td><td class=\"count\">2265</td></tr>
<tr class=\"content span-6\"><td colspan=\"6\"><a href=\"/collections/#{@collection.id}/works?filter%5Bcondition_work_id%5D%5B%5D=4\">Slecht (--)</a></td><td class=\"count\">83</td></tr>
<tr class=\"content span-6\"><td colspan=\"6\"><a href=\"/collections/#{@collection.id}/works?filter%5Bcondition_work_id%5D%5B%5D=3\">Matig (-)</a></td><td class=\"count\">38</td></tr>
<tr class=\"content span-6\"><td colspan=\"6\"><a href=\"/collections/#{@collection.id}/works?filter%5Bcondition_work%5D%5B%5D=not_set\">Niets ingevuld</a></td><td class=\"count\">19</td></tr>
<tr class=\"content span-6\"><td colspan=\"6\"><a href=\"/collections/#{@collection.id}/works?filter%5Bcondition_work_id%5D%5B%5D=2\">Redelijk/Voldoende (+)</a></td><td class=\"count\">2</td></tr>
<tr class=\"group_separator\"><td colspan=\"7\"></td></tr></table>")
    end
    it "should render a report with numbers" do
      expect(helper.render_report_section([:object_creation_year])).to eq("<table><tr class=\"section object_creation_year span-7\"><th colspan=\"8\">Datering (jaar)</th></tr>
<tr class=\"content span-6\"><td colspan=\"6\"><a href=\"/collections/#{@collection.id}/works?filter%5Bobject_creation_year%5D%5B%5D=2002\">2002</a></td><td class=\"count\">109</td></tr>
<tr class=\"content span-6\"><td colspan=\"6\"><a href=\"/collections/#{@collection.id}/works?filter%5Bobject_creation_year%5D%5B%5D=not_set\">Niets ingevuld</a></td><td class=\"count\">993</td></tr>
<tr class=\"group_separator\"><td colspan=\"7\"></td></tr></table>")
    end
    it "should render a report with a string/key" do
      expect(helper.render_report_section([:"object_format_code.keyword"])).to eq("<table><tr class=\"section object_format_code span-7\"><th colspan=\"8\">Formaatcode</th></tr>
<tr class=\"content span-6\"><td colspan=\"6\"><a href=\"/collections/#{@collection.id}/works?filter%5Bobject_format_code.keyword%5D%5B%5D=m\">m</a></td><td class=\"count\">1083</td></tr>
<tr class=\"content span-6\"><td colspan=\"6\"><a href=\"/collections/#{@collection.id}/works?filter%5Bobject_format_code.keyword%5D%5B%5D=l\">l</a></td><td class=\"count\">553</td></tr>
<tr class=\"content span-6\"><td colspan=\"6\"><a href=\"/collections/#{@collection.id}/works?filter%5Bobject_format_code.keyword%5D%5B%5D=s\">s</a></td><td class=\"count\">357</td></tr>
<tr class=\"content span-6\"><td colspan=\"6\"><a href=\"/collections/#{@collection.id}/works?filter%5Bobject_format_code.keyword%5D%5B%5D=xl\">xl</a></td><td class=\"count\">211</td></tr>
<tr class=\"content span-6\"><td colspan=\"6\"><a href=\"/collections/#{@collection.id}/works?filter%5Bobject_format_code.keyword%5D%5B%5D=xs\">xs</a></td><td class=\"count\">132</td></tr>
<tr class=\"content span-6\"><td colspan=\"6\"><a href=\"/collections/#{@collection.id}/works?filter%5Bobject_format_code.keyword%5D%5B%5D=not_set\">Formaatcode onbekend</a></td><td class=\"count\">71</td></tr>
<tr class=\"group_separator\"><td colspan=\"7\"></td></tr></table>")
    end
    it "should created the proper nested urls" do
      @object_categories_split_result = helper.render_report_section([:object_categories_split])


      ["/collections/#{@collection.id}/works?filter%5Bobject_categories.id%5D%5B%5D=4",
      "/collections/#{@collection.id}/works?filter%5Bobject_categories.id%5D%5B%5D=4&amp;filter%5Btechniques.id%5D%5B%5D=33",
      "/collections/#{@collection.id}/works?filter%5Bobject_categories.id%5D%5B%5D=4&amp;filter%5Btechniques.id%5D%5B%5D=7",
      "/collections/#{@collection.id}/works?filter%5Bobject_categories.id%5D%5B%5D=4&amp;filter%5Btechniques.id%5D%5B%5D=17",
      "/collections/#{@collection.id}/works?filter%5Bobject_categories.id%5D%5B%5D=4&amp;filter%5Btechniques.id%5D%5B%5D=13",
      "/collections/#{@collection.id}/works?filter%5Bobject_categories.id%5D%5B%5D=4&amp;filter%5Btechniques.id%5D%5B%5D=16",
      "/collections/#{@collection.id}/works?filter%5Bobject_categories.id%5D%5B%5D=4&amp;filter%5Btechniques.id%5D%5B%5D=35",
      "/collections/#{@collection.id}/works?filter%5Bobject_categories.id%5D%5B%5D=4&amp;filter%5Btechniques.id%5D%5B%5D=45",
      "/collections/#{@collection.id}/works?filter%5Bobject_categories.id%5D%5B%5D=4&amp;filter%5Btechniques%5D%5B%5D=not_set",
      "/collections/#{@collection.id}/works?filter%5Bobject_categories.id%5D%5B%5D=4&amp;filter%5Btechniques.id%5D%5B%5D=9",
      "/collections/#{@collection.id}/works?filter%5Bobject_categories.id%5D%5B%5D=4&amp;filter%5Btechniques.id%5D%5B%5D=91",
      "/collections/#{@collection.id}/works?filter%5Bobject_categories.id%5D%5B%5D=4&amp;filter%5Btechniques.id%5D%5B%5D=158",
      "/collections/#{@collection.id}/works?filter%5Bobject_categories.id%5D%5B%5D=4&amp;filter%5Btechniques.id%5D%5B%5D=92",
      "/collections/#{@collection.id}/works?filter%5Bobject_categories.id%5D%5B%5D=4&amp;filter%5Btechniques.id%5D%5B%5D=137",
      "/collections/#{@collection.id}/works?filter%5Bobject_categories.id%5D%5B%5D=4&amp;filter%5Btechniques.id%5D%5B%5D=162",
      "/collections/#{@collection.id}/works?filter%5Bobject_categories.id%5D%5B%5D=4&amp;filter%5Btechniques.id%5D%5B%5D=12",
      "/collections/#{@collection.id}/works?filter%5Bobject_categories.id%5D%5B%5D=4&amp;filter%5Btechniques.id%5D%5B%5D=172",
      "/collections/#{@collection.id}/works?filter%5Bobject_categories.id%5D%5B%5D=4&amp;filter%5Btechniques.id%5D%5B%5D=4",
      "/collections/#{@collection.id}/works?filter%5Bobject_categories.id%5D%5B%5D=4&amp;filter%5Btechniques.id%5D%5B%5D=72"].each do |link|
        @object_categories_split_result.match(link)
      end
    end
  end
  describe "#iterate_report_sections" do
    before(:each) do
      @collection = collections(:collection1)
      allow(helper).to receive(:report).and_return (
        {
          :"object_format_code.keyword"=>{"m"=>{:count=>1083, :subs=>{}}, "l"=>{:count=>553, :subs=>{}}, "s"=>{:count=>357, :subs=>{}}, "xl"=>{:count=>211, :subs=>{}}, "xs"=>{:count=>132, :subs=>{}}, :missing=>{:count=>71, :subs=>{}}},
          :frame_damage_types=>{},
        }
      )
    end
    it "should work" do
      section = helper.report[:"object_format_code.keyword"]
      expect(iterate_report_sections("object_format_code.keyword", section, 7)).to eq("<tr class=\"section object_format_code span-7\"><th colspan=\"8\">Formaatcode</th></tr>
<tr class=\"content span-6\"><td colspan=\"6\">m</td><td class=\"count\">1083</td></tr>
<tr class=\"content span-6\"><td colspan=\"6\">l</td><td class=\"count\">553</td></tr>
<tr class=\"content span-6\"><td colspan=\"6\">s</td><td class=\"count\">357</td></tr>
<tr class=\"content span-6\"><td colspan=\"6\">xl</td><td class=\"count\">211</td></tr>
<tr class=\"content span-6\"><td colspan=\"6\">xs</td><td class=\"count\">132</td></tr>
<tr class=\"content span-6\"><td colspan=\"6\"><a href=\"/collections/#{@collection.id}/works?filter%5Bobject_format_code.keyword%5D%5B%5D=not_set\">Niets ingevuld</a></td><td class=\"count\">71</td></tr>
<tr class=\"group_separator\"><td colspan=\"7\"></td></tr>")
    end
  end
end
