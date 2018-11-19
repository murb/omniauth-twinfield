require 'rails_helper'

RSpec.describe ImportCollection, type: :model do
  describe "instance methods" do
    describe "#internal_header_row_offset" do
      it "should work humanely" do
        i = ImportCollection.new
        expect(i.internal_header_row_offset).to eq(0)
        i.header_row = 0
        expect(i.internal_header_row_offset).to eq(0)
        i.header_row = 1
        expect(i.internal_header_row_offset).to eq(0)
        i.header_row = 2
        expect(i.internal_header_row_offset).to eq(1)
      end
    end
    describe "#workbook" do
      it "should update import settings" do
        i = ImportCollection.create(file: File.open(File.join(Rails.root,"spec","fixtures","import_collection_file.csv")))
        expect(i.workbook.class).to eq(Workbook::Book)
      end
    end
    describe "#import_file_to_workbook_table" do
      it "should return the table" do
        i = ImportCollection.create(file: File.open(File.join(Rails.root,"spec","fixtures","import_collection_file.csv")))
        expect(i.import_file_to_workbook_table.class).to eq(Workbook::Table)
        expect(i.import_file_to_workbook_table.to_csv).to match("artist_name,work_title,Drager,Niveau")
        expect(i.import_file_to_workbook_table.to_csv).to match("Achternaam,Zonder Titel,doek,A")
        expect(i.import_file_to_workbook_table.to_csv).to match("Andere Achternaam,Zonder Unieke Titel,Papier,C")
        expect(i.import_file_to_workbook_table.to_csv).to match("onbekend,Uniek,,D,\"earth, wind\"\nOnbekend,Uniek2,,G")
      end
    end
    describe "#update" do
      it "should allow for updating import settings" do
        i = ImportCollection.create(file: File.open(File.join(Rails.root,"spec","fixtures","import_collection_file.csv")))
        i.update("import_settings"=>{"title"=>{"split_strategy"=>"split_nothing", "assign_strategy"=>"append", "fields"=>["work.title"]}})
        expect(i.import_settings).to eq({"title"=>{"split_strategy"=>"split_nothing", "assign_strategy"=>"append", "fields"=>["work.title"]}})
      end
    end
    describe "#read" do
      it "should work" do
        i = ImportCollection.create(file: File.open(File.join(Rails.root,"spec","fixtures","import_collection_file.csv")))
        i.collection = collections(:collection1)
        i.update("import_settings"=>{
          "work_title"=>{"split_strategy"=>"split_nothing", "assign_strategy"=>"append", "fields"=>["work.title"]},
          "artist_name"=>{"split_strategy"=>"split_space", "assign_strategy"=>"append", "fields"=>["artist.first_name", "artist.last_name"]},
          "Drager"=>{"split_strategy"=>"find_keywords", "assign_strategy"=>"replace", "fields"=>["work.medium"]},
          "Niveau"=>{"split_strategy"=>"split_nothing", "assign_strategy"=>"replace", "fields"=>["work.grade_within_collection"]},
          "Thema's"=>{"split_strategy"=>"find_keywords", "assign_strategy"=>"append", "fields"=>["work.themes"]},
        })
        read = i.read
        read.each{|a| a.save; a.reload}
        expect(read[0].title).to eq(nil)
        expect(read[0].title_unknown).to eq(true)
        expect(read[0].id).to be > 0
        expect(read[1].id).to be > 0
        expect(read[2].id).to be > 0
        expect(read[3].id).to be > 0
        expect(read[1].title).to eq("Zonder Unieke Titel")
        expect(read[1].title_unknown).to be_falsy
        expect(read[1].themes.collect{|a| a.name}).to eq(["earth", "wind"])
        expect(read[0].themes.collect{|a| a.name}).to eq(["earth"])
        expect(read[3].themes.collect{|a| a.name}).to eq(["fire"])
        expect(read[1].medium.name).to eq("Papier")
        expect(read[2].medium).to be_nil
        expect(read[0].grade_within_collection).to eq("A")
        expect(read[1].grade_within_collection).to eq("C")
        expect(read[0].artist_unknown).to be_falsy

        expect(read[0].collection).to eq(collections(:collection1))
        expect(read[1].collection).to eq(collections(:collection1))
        expect(read[2].collection).to eq(collections(:collection1))
        expect(read[3].collection).to eq(collections(:collection1))
        expect(read[3].artists).to eq([])
        expect(read[3].artist_unknown).to be_truthy
        expect(read[2].artists).to eq([])
      end
      it "should not import into a different collection" do
        i = ImportCollection.create(file: File.open(File.join(Rails.root,"spec","fixtures","import_collection_file_edge_cases.csv")))
        i.collection = collections(:collection1)
        i.update("import_settings"=>{
          "work_title"=>{"split_strategy"=>"split_nothing", "assign_strategy"=>"append", "fields"=>["work.title"]},
          "artist_name"=>{"split_strategy"=>"split_space", "assign_strategy"=>"append", "fields"=>["artist.first_name", "artist.last_name"]},
          "Drager"=>{"split_strategy"=>"find_keywords", "assign_strategy"=>"replace", "fields"=>["work.medium"]},
          "Niveau"=>{"split_strategy"=>"split_nothing", "assign_strategy"=>"replace", "fields"=>["work.grade_within_collection"]},
          "Thema's"=>{"split_strategy"=>"find_keywords", "assign_strategy"=>"append", "fields"=>["work.themes"]},
          "Collectie"=>{"split_strategy"=>"find_keywords", "assign_strategy"=>"replace", "fields"=>["work.collection"]},
          "Cluster"=>{"split_strategy"=>"find_keywords", "assign_strategy"=>"replace", "fields"=>["work.cluster"]},
        })
        read = i.read
        expect(read.count).to eq(4)
        expect(read[2].collection).to eq(collections(:collection_with_works))
      end
    end
  end
  describe "class methods" do
    describe ".import_type.new(parameters)" do
      it "should create a new work" do
        expect(ImportCollection.import_type.new(title: "abc").title).to eq("abc")
      end
    end
  end
end
