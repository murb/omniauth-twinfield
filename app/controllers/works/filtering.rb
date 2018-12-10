module Works::Filtering
  extend ActiveSupport::Concern

  included do
    private

    def set_selection_filter
      @selection_filter = current_user.filter_params[:filter] ? current_user.filter_params[:filter] : {}
      if params[:filter] or params[:group] or params[:sort] or params[:display]
        @selection_filter = {}
      end
      if params[:filter] and params[:filter] != ""
        params[:filter].each do |field, values|
          if field == "reset"
            @reset = true
          elsif ["grade_within_collection","abstract_or_figurative","object_format_code.keyword","location","location_raw.keyword", "location_floor_raw.keyword", "location_detail_raw.keyword", "main_collection", "tag_list.keyword"].include?(field)
            @selection_filter[field] =  params[:filter][field].collect{|a| a == "not_set" ? nil : a} if params[:filter][field]
          else
            @selection_filter[field] = clean_ids(values)
          end
        end
      end
      return @selection_filter
    end
    def set_selection thing, list
      @selection[thing] = list[0]
      if params[thing] and list.include? params[thing].to_sym
        @selection[thing] = params[thing].to_sym
      elsif current_user.filter_params[thing]
        @selection[thing] = current_user.filter_params[thing].to_sym
      end
      @selection[thing]
    end
    def set_selection_group
      set_selection :group, [:no_grouping, :cluster, :subset, :placeability, :grade_within_collection, :themes, :techniques, :sources]
    end
    def set_selection_sort
      set_selection :sort, [:stock_number, :artist_name]
    end
    def set_selection_display
      set_selection :display, [:compact, :detailed, :complete, :limited, :limited_auction]
    end

    def set_selection_group_options
      proto_selection_group_options = {
        "Niet"=>:no_grouping,
        "Cluster"=>:cluster,
        "Deelcollectie"=>:subset,
        "Herkomst"=>:sources,
        "Niveau"=>:grade_within_collection,
        "Plaatsbaarheid"=>:placeability,
        "Techniek"=>:techniques,
        "Thema"=>:themes,
      }
      @selection_group_options = {}
      proto_selection_group_options.each do |k,v|
        @selection_group_options[k] = v if current_user.can_filter_and_group?(v)
      end
    end

    def set_selection_display_options
      @selection_display_options = {"Compact"=>:compact, "Basis"=>:detailed}
      @selection_display_options["Compleet"] = :complete unless current_user.read_only?
      if current_user.qkunst?
        @selection_display_options["Beperkt"] = :limited
        @selection_display_options["Veilinghuis"] = :limited_auction
        @limit_collection_information = true
      end
    end

    def update_current_user_with_params
      current_user.filter_params[:group] = @selection[:group]
      current_user.filter_params[:display] = @selection[:display]
      current_user.filter_params[:sort] = @selection[:sort]
      current_user.filter_params[:filter] = @selection_filter
      current_user.save
    end
    def sort_works works
      if @selection[:sort].to_s == "artist_name"
        works = works.sort{|a,b| a.artist_name_rendered.to_s.downcase <=> b.artist_name_rendered.to_s.downcase}
      else
        works = works.sort{|a,b| a.stock_number.to_s.downcase <=> b.stock_number.to_s.downcase}
      end
      works
    end
  end
end