# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Collection, type: :model do
  describe "callbacks" do
    describe "after save" do
      it "touches child works" do
        collection = collections(:collection_with_works)
        w = collection.works.first
        w_originally_updated_at = w.updated_at
        sleep(0.001)
        collection.save
        w.reload
        expect(w.updated_at).to be > w_originally_updated_at
      end

      it "doesn't change collection_locality_artist_involvements_texts_cache" do
        collection = collections(:collection_with_works)
        w = collection.works.first
        w.update_column(:collection_locality_artist_involvements_texts_cache, "['abc']")
        collection.save
        w.reload
        expect(w.collection_locality_artist_involvements_texts_cache).to eq("['abc']")
      end

      it "does change collection_locality_artist_involvements_texts_cache when locality has been updated" do
        collection = collections(:collection_with_works)
        w = collection.works.first
        w.update_column(:collection_locality_artist_involvements_texts_cache, "['abc']")

        collection.collections_geoname_summaries = [CollectionsGeonameSummary.new(geoname_summary: geoname_summaries(:geoname_summary1))]
        collection.save
        w.reload
        expect(w.collection_locality_artist_involvements_texts_cache).not_to eq("['abc']")

      end
    end
  end
  describe "methods" do
    describe "#available_clusters" do
      it "should list all private clusters" do
        expect(collections(:collection_with_works).available_clusters).to include(clusters(:cluster1))
        expect(collections(:collection_with_works).available_clusters).to include(clusters(:cluster2))
        expect(collections(:collection1).available_clusters).to include(clusters(:cluster1))
        expect(collections(:collection1).available_clusters).to include(clusters(:cluster2))
      end
      it "should list not list private clusters" do
        expect(collections(:collection_with_stages).available_clusters).not_to include(clusters(:cluster1))
        expect(collections(:collection_with_stages).available_clusters).not_to include(clusters(:cluster2))
      end
    end

    describe "#available_themes" do
      it "should include all generic themes" do
        col_1_available_themes = collections(:collection1).available_themes
        expect(col_1_available_themes).to include(themes(:earth))
      end
      it "should not include hidden generic themes" do
        col_1_available_themes = collections(:collection1).available_themes
        expect(col_1_available_themes).not_to include(themes(:old))
      end
      it "should not include themes that belong to another collection" do
        col_1_available_themes = collections(:collection1).available_themes
        expect(col_1_available_themes).not_to include(themes(:wind_private_to_collection_with_stages))
      end
      it "should include collection specific themes if any" do
        col_with_stages_available_themes = collections(:collection_with_stages).available_themes
        expect(col_with_stages_available_themes).not_to include(themes(:old))
        expect(col_with_stages_available_themes).to include(themes(:wind_private_to_collection_with_stages))
        expect(col_with_stages_available_themes).to include(themes(:earth))
        expect(col_with_stages_available_themes).to include(themes(:wind))
      end
    end

    describe "#child_collections_flattened" do
      it "should return all childs" do
        expect(collections(:collection1).child_collections_flattened.map(&:id).sort).to eq([collections(:collection2),collections(:collection4), collections(:collection_with_works),collections(:collection_with_works_child)].map(&:id).sort)
      end
    end

    describe "#expand_with_child_collections" do
      it "should return all collections when expanded from root" do
        expect(collections(:root_collection).expand_with_child_collections.count).to eq(Collection.all.count)
      end
      it "should return empty array when no id" do
        expect(Collection.new.expand_with_child_collections).to eq([])
      end
      it "should return subset for collection1" do
        collections = collections(:collection1).expand_with_child_collections.all
        expect(collections).to include(collections(:collection1))
        expect(collections).to include(collections(:collection_with_works))
        expect(collections).to include(collections(:collection_with_works_child))

        expect(collections).not_to include(collections(:collection3))
      end
    end

    describe "#expand_with_parent_collections" do
      it "should return only the root when expanded from root" do
        expect(collections(:root_collection).expand_with_parent_collections).to eq([Collection.root_collection])
      end
      it "should return all parents" do
        expect(collections(:collection_with_works_child).expand_with_parent_collections).to match_array([Collection.root_collection, collections(:collection_with_works_child), collections(:collection_with_works), collections(:collection1)])
      end
    end

    describe "#fields_to_expose" do
      it "should return almost all fields when fields_to_expose(:default)" do
        collection = collections(:collection4)
        fields = collection.fields_to_expose(:default)

        ["location", "location_floor", "location_detail", "stock_number", "alt_number_1", "alt_number_2", "alt_number_3", "information_back", "artists", "artist_unknown", "title", "title_unknown", "description", "object_creation_year", "object_creation_year_unknown", "object_categories", "techniques", "medium", "medium_comments", "signature_comments", "no_signature_present", "print", "frame_height", "frame_width", "frame_depth", "frame_diameter", "height", "width", "depth", "diameter", "condition_work", "damage_types", "condition_work_comments", "condition_frame", "frame_damage_types", "condition_frame_comments", "placeability", "other_comments", "sources", "source_comments", "abstract_or_figurative", "style", "themes", "subset", "purchased_on", "purchase_price", "purchase_price_currency", "price_reference", "grade_within_collection", "public_description", "internal_comments", "imported_at", "id", "created_at", "updated_at", "created_by", "appraisals", "versions", "collection", "external_inventory", "cluster", "version", "artist_name_rendered", "valuation_on", "lognotes", "market_value", "replacement_value"].each do |a|
          expect(fields).to include(a)
        end
      end
    end

    describe "#main_collection" do
      it "should return self if no main collection exists" do
        expect(collections(:boring_collection).base_collection).to eq(collections(:boring_collection))
        expect(collections(:sub_boring_collection).base_collection).to eq(collections(:sub_boring_collection))
      end

      it "should return the parent collection marked as base when it exists" do
        expect(collections(:collection_with_works_child).base_collection).to eq(collections(:collection_with_works))
        expect(collections(:collection_with_works).base_collection).to eq(collections(:collection_with_works))
      end
    end

    describe "#parent_collections_flattened" do
      it "should return the oldest parent, then that child ." do
        collection = collections(:collection4)
        expect(collection.parent_collections_flattened[0]).to eq(collections(:collection1))
        expect(collection.parent_collections_flattened[1]).to eq(collections(:collection2))
        expect(collection.parent_collections_flattened[2]).to eq(nil)
      end
    end

    describe "#sort_works_by" do
      it "should not accept noise" do
        c = collections(:collection1)
        c.sort_works_by= "asdf"
        expect(c.sort_works_by).to eq nil
      end
      it "should not valid value" do
        c = collections(:collection1)
        c.sort_works_by= "created_at"
        expect(c.sort_works_by).to eq :created_at
      end
    end

    describe "#works_including_child_works" do
      it "should return all child works" do
        child_works = collections(:collection3).works_including_child_works
        expect(child_works).to include(works(:work6))
      end
      it "should return child collections' works" do
        child_works = collections(:collection1).works_including_child_works
        expect(child_works).not_to include(works(:work6))
        expect(child_works).to include(works(:work1))
      end
    end

  end
  describe "Class methods" do
    describe ".for_user_or_if_no_user_all" do
      it "returns all for nil user" do
        expect(Collection.for_user_or_if_no_user_all.all.collect(&:id).sort).to eq(Collection.not_system.all.collect(&:id).sort)
      end

      it "returns all for admin user" do
        expect(Collection.for_user_or_if_no_user_all(users(:admin)).all.collect(&:id).sort).to eq(Collection.not_system.all.collect(&:id).sort)
      end

      it "returns only base collection for user" do
        expect(Collection.for_user(users(:facility_manager))).to eq([collections(:collection1)])
      end
    end
    describe ".expand_with_child_collections" do
      it "returns child collections" do
        set = Collection.where(name: "Collection 1").expand_with_child_collections
        # expect(set.class).to eq(Collection::ActiveRecord_Relation)
        expect(set.map(&:id).sort).to eq([collections(:collection1),collections(:collection2),collections(:collection4),collections(:collection_with_works),collections(:collection_with_works_child)].map(&:id).sort)
      end
      it "returns child collections until depth 1" do
        set = Collection.where(name: "Collection 1").expand_with_child_collections(2)
        # expect(set.class).to eq(Collection::ActiveRecord_Relation)
        expect(set.map(&:id).sort).to eq([collections(:collection1),collections(:collection2),collections(:collection_with_works)].map(&:id).sort)
      end
      it "works with larger start-set that includes child" do
        set = Collection.where(name: ["Collection 1", "Collection 2"]).expand_with_child_collections
        # expect(set.class).to eq(Collection::ActiveRecord_Relation)
        expect(set.map(&:id).sort).to eq([collections(:collection1),collections(:collection2),collections(:collection4),collections(:collection_with_works),collections(:collection_with_works_child)].map(&:id).sort)
      end
      it "works with larger start-set that does not  include child" do
        set = Collection.where(name: ["Collection 1", "Collection 3"]).expand_with_child_collections
        # expect(set.class).to eq(Collection::ActiveRecord_Relation)
        expect(set.map(&:id).sort).to eq([collections(:collection1),collections(:collection2),collections(:collection3),collections(:collection4),collections(:collection_with_works),collections(:collection_with_works_child)].map(&:id).sort)
      end
    end
  end
  describe "Scopes" do
    describe ".artist" do
      it "should return all works by certain artist" do
        artist_works = Work.artist(artists(:artist1))
        artists(:artist1).works.each do |work|
          expect(artist_works).to include(work)
        end
      end
      it "should return all works by certain artist, but not expand scope" do
        artist_works = collections(:collection3).works_including_child_works.artist(artists(:artist4))
        artist_works.each do |work|
          expect(work.artists).to include(artists(:artist4))
        end
        artist_works.each do |work|
          expect(work.collection).to eq(collections(:collection3))
        end
      end
    end
  end
end
