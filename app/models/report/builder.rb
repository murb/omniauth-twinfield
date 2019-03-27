# frozen_string_literal: true

module Report
  class Builder
    extend Report::BuilderHelpers

    class << self
      def aggregations
        aggregation = {
          total: {
            value_count: {
              field: :id
            }
          },
          artists: {
            terms: {
              field: "report_val_sorted_artist_ids.keyword", size: 999
            }
          },
          object_categories: {
            terms: {
              field: "report_val_sorted_object_category_ids.keyword", size: 999
            },
            aggs: {
              techniques: {
                terms: {
                  field: "report_val_sorted_technique_ids.keyword", size: 999
                }
              },
              techniques_missing: {
                missing: {
                  field: "report_val_sorted_technique_ids.keyword"
                }
              }
            }
          },

          object_categories_split: {
            terms: {
              field: "report_val_sorted_object_category_ids.keyword", size: 999
            },
            aggs: {
              techniques: {
                terms: {
                  field: "techniques.id", size: 999
                }
              },
              techniques_missing: {
                missing: {
                  field: "techniques.id"
                }
              }
            }
            }
        }

        [:subset, :style, :frame_type].each do |key|
          aggregation.merge!(basic_aggregation_snippet(key,"_id"))
        end

        [:condition_work, :condition_frame, :sources, :placeability, :themes, :owner, :cluster].each do |key|
          aggregation.merge!(basic_aggregation_snippet_with_missing(key,".id"))
        end

        [:damage_types, :frame_damage_types].each do |key|
          aggregation.merge!(basic_aggregation_snippet(key,".id"))
        end

        ["abstract_or_figurative.keyword", "grade_within_collection.keyword", "object_format_code.keyword", "tag_list.keyword", :market_value, :replacement_value, :object_creation_year, :purchase_year, :publish, :image_rights].each do |key|
          aggregation.merge!(basic_aggregation_snippet_with_missing(key))
        end

        [:inventoried, :refound, :new_found].each do |key|
          aggregation.merge!(basic_aggregation_snippet(key))
        end

        location_sub_sub = basic_aggregation_snippet_with_missing("location_detail_raw.keyword")

        location_sub = basic_aggregation_snippet_with_missing("location_floor_raw.keyword")
        location_sub.keys.each do |key|
          location_sub[key][:aggs] = location_sub_sub
        end

        location = basic_aggregation_snippet_with_missing("location_raw.keyword")
        location.keys.each do |key|
          location[key][:aggs] = location_sub
        end

        aggregation.merge!(location)

        return aggregation
      end


    end
  end
end
