# frozen_string_literal: true

class FakeSuperCollection
  def name
    "Algemeen"
  end

  def themes
    Theme.general
  end

  def not_hidden_themes
    themes.not_hidden
  end
end

class CollectionBaseError < StandardError

end

class Collection < ApplicationRecord
  include ColumnCache
  include Collection::Hierarchy

  belongs_to :parent_collection, class_name: 'Collection', optional: true

  has_and_belongs_to_many :users
  has_and_belongs_to_many :stages

  has_many :attachments, as: :attache
  has_many :batch_photo_uploads
  has_many :child_collections, class_name: 'Collection', foreign_key: 'parent_collection_id'
  has_many :clusters
  has_many :collections, class_name: 'Collection', foreign_key: 'parent_collection_id'
  has_many :collections_geoname_summaries
  has_many :custom_reports
  has_many :geoname_summaries, through: :collections_geoname_summaries
  has_many :import_collections
  has_many :themes
  has_many :works
  has_many :owners
  has_many :messages, as: :subject_object
  has_many :collections_stages
  has_many :reminders

  has_cache_for_column :geoname_ids
  has_cache_for_column :collection_name_extended

  default_scope ->{order(:collection_name_extended_cache)}

  scope :without_parent, ->{ where(parent_collection_id: nil) }
  scope :not_hidden, ->{ where("1=1")}
  scope :not_system, ->{ not_root }

  before_save :cache_geoname_ids!
  before_save :cache_collection_name_extended!
  before_save :attach_sub_collection_ownables_when_base

  after_create :copy_default_reminders!
  after_save :touch_works_including_child_works!
  after_save :cache_all_collection_name_extended!

  after_commit :touch_parent

  KEY_MODEL_RELATIONS={
    "artists"=>"Artist",
    "themes"=>"Theme",
    "object_categories"=>"ObjectCategory",
    "object_categories_split"=>"ObjectCategory",
    "techniques"=>"Technique",
    "condition_frame"=>"Condition",
    "techniques_split"=>"Technique",
    "condition_work"=>"Condition",
    "frame_damage_types"=>"FrameDamageType",
    "damage_types"=>"DamageType",
    "placeability"=>"Placeability",
    "style"=>"Style",
    "subset"=>"Subset",
    "source"=>"Source",
    "sources"=>"Source",
    "cluster"=>"Cluster",
    "owner"=>"Owner",
    "frame_type"=>"FrameType"
  }

  def find_state_of_stage(stage)
    collections_stages.to_a.each do |cs|
      return cs if cs.stage == stage
    end
    return nil
  end

  def base_collection
    if base
      return self
    else
      base_collections.last || self
    end
  end

  def base_collections
    expand_with_parent_collections(:desc).not_system.where(base:true)
  end

  def base_collection?
    base_collection == self
  end

  def collections_stages?
    collections_stages.count > 0
  end

  def parent_collection_with_stages
    unless collections_stages?
      parent_collections_flattened.reverse.each do |coll|
        return coll if coll.collections_stages?
      end
    end
    return nil
  end

  def appraise_with_ranges
    read_attribute(:appraise_with_ranges) || (self_and_parent_collections_flattened.where(appraise_with_ranges: true).count > 0)
  end
  alias_method :appraise_with_ranges?, :appraise_with_ranges

  def sort_works_by= value
    write_attribute(:sort_works_by, (Work::SORTING_FIELDS & [value.to_sym]).first)
  end

  def sort_works_by
    read_attribute(:sort_works_by).try(:to_sym)
  end

  def geoname_ids
    geoname_summaries.collect{|a| a.geoname_id}
  end

  def geoname_summaries?
    cached_geoname_ids && cached_geoname_ids.count > 0
  end

  def self_or_parent_collection_with_geoname_summaries
    if geoname_summaries?
      return self
    else
      parent_collections_flattened.reverse.each do |coll|
        return coll if coll.geoname_summaries?
      end
    end
    return nil
  end

  def collections_stage_delivery_on
    if collections_stages.delivery.count > 0
      rv = collections_stages.delivery.first.completed_at
      rv.to_date if rv
    end
  end

  def collections_stage_delivery_on= date
    if collections_stages.delivery.count > 0
      collections_stage = collections_stages.delivery.first
      collections_stage.completed_at = date
      collections_stage.save
    end
  end

  def artists
    Artist.works(works_including_child_works)
  end

  def works_including_child_works
    Work.where(collection: expand_with_child_collections)
  end

  def touch_parent
    parent_collection.touch if parent_collection
  end

  def touch_works_including_child_works!
    if previous_changes.keys.include? "geoname_ids_cache"
      works_including_child_works.each{|a| a.save}
    else
      works_including_child_works.each{|a| a.touch}
    end
  end

  def available_clusters
    Cluster.for_collection(self)
  end

  def system?
    self.root?
  end

  def available_owners
    Owner.for_collection(self)
  end

  def available_themes
    Theme.for_collection_including_generic(self).not_hidden
  end

  def not_hidden_themes
    themes.not_hidden
  end

  def users_including_parent_users
    (users + parent_collections_flattened.collect{|a| a.users_including_parent_users}).flatten.uniq
  end

  def exposable_fields= array
    write_attribute(:exposable_fields,array.collect{|a| a.to_s.strip if a and a.to_s.strip != ""}.compact.join(","))
  end

  def collection_name_extended
    @collection_name_extended ||= self_and_parent_collections_flattened.map(&:name).join(" » ")
  end

  def cached_collection_name_extended_with_fallback
    cached_collection_name_extended || collection_name_extended
  end
  alias_method :to_label, :cached_collection_name_extended_with_fallback

  def exposable_fields
    read_attribute(:exposable_fields).to_s.split(",")
  end

  def fields_to_expose(audience=:default)
    if audience == :default
      if exposable_fields.count == 0
        fields = Work.possible_exposable_fields.collect{|k,v| v}
        return fields
      else
        return exposable_fields
      end
    elsif audience == :erfgoed_gelderland
      fields = ["stock_number_file_safe","title_rendered","description","public_description", "object_creation_year", "tags", "object_categories","medium","techniques","hpd_height","hpd_width","hpd_depth","hpd_diameter","hpd_photo_file_name"]
      5.times do | artist_index |
        [:first_name, :prefix, :last_name, :rkd_artist_id, :year_of_birth, :year_of_death].each do |artist_property|
          fields << "artist_#{artist_index}_#{artist_property}"
        end
      end
      fields
    end
  end

  def elastic_aggragations
    elastic_report = search_works("",{},{force_elastic: true, return_records: false, limit: 1, aggregations: Report::Builder.aggregations})
    return elastic_report.aggregations
  rescue Faraday::ConnectionFailed => e
    SystemMailer.error_message(e).deliver_now
    return false
  end

  def label_override_work_alt_number_1_with_inheritance
    self_and_parent_collections_flattened.collect{|a| a.label_override_work_alt_number_1 unless a.label_override_work_alt_number_1.to_s.strip == ""}.compact.last
  end

  def label_override_work_alt_number_2_with_inheritance
    self_and_parent_collections_flattened.collect{|a| a.label_override_work_alt_number_2 unless a.label_override_work_alt_number_2.to_s.strip == ""}.compact.last
  end

  def label_override_work_alt_number_3_with_inheritance
    self_and_parent_collections_flattened.collect{|a| a.label_override_work_alt_number_3 unless a.label_override_work_alt_number_3.to_s.strip == ""}.compact.last
  end

  def geoname_summary_values
    rv = {}
    geoname_summaries.each do |gs|
      rv[gs.name]=gs.geoname_id
    end
    rv
  end

  def report
    return @report if @report
    Report::Parser.key_model_relations= KEY_MODEL_RELATIONS.map{|k,v| [k,v.constantize]}.to_h
    if elastic_aggragations
      @report = Report::Parser.parse(elastic_aggragations)
    else
      return false
    end
  end

  def search_works(search="", filter={}, options={})
    options = {force_elastic: false, return_records: true, limit: 50000}.merge(options)
    sort = options[:sort] || ["_score"]
    if ((search == "" or search == nil) and (filter == nil or filter == {} or (
      filter.is_a? Hash and filter.sum{|k,v| v.count} == 0
      )) and options[:force_elastic] == false)
      return options[:no_child_works] ? works.limit(options[:limit]) : works_including_child_works.limit(options[:limit])
    end

    query = {
      _source: [:id], #major speedup!
      size: options[:limit],
      query:{
        bool: {
          must: [
            terms:{
              "collection_id"=> options[:no_child_works] ? [id] : expand_with_child_collections.map(&:id)
            }
          ]
        }
      },
      sort: sort
    }

    if (search and !search.to_s.strip.empty?)
      search = search.match(/[\"\(\~\'\*\?]|AND|OR/) ? search : search.split(" ").collect{|a| "#{a}~" }.join(" ")
      query[:query][:bool][:must] << {
        query_string: {
          default_field: :_all,
          query: search,
          default_operator: :and,
          fuzziness: 3
        }
      }
    end

    filter.each do |key, values|
      new_bool = {bool: {should: []}}
      if key == "locality_geoname_id" or key == "geoname_ids" or key == "tag_list"
        values = values.compact
        if values.count == 0
          new_bool[:bool]= {mustNot: {exists: {field: key}}}
        else
          new_bool[:bool][:should] << {terms: {key=> values}}
        end
      else
        values.each do |value|
          if value != nil
            new_bool[:bool][:should] << {term: {key=>value}}
          else
            if key.ends_with?(".id")
              new_bool[:bool][:should] << {mustNot: {exists: {field: key}}}
            else
              new_bool[:bool][:should] << {bool:{must_not: {exists: {field: key }}}}
            end
          end
        end
      end
      query[:query][:bool][:must] << new_bool
    end

    query[:aggs] = options[:aggregations] if options[:aggregations]

    if options[:return_records]
      return Work.search(query).records
    else
      return Work.search(query)
    end
  end

  def can_be_accessed_by_user user
    users_including_parent_users.include? user or user.admin?
  end
  alias_method :can_be_accessed_by_user?, :can_be_accessed_by_user

  def copy_default_reminders!
    if reminders.count == 0
      Reminder.prototypes.each do |a|
        self.reminders << Reminder.new(a.to_hash)
      end
    end
  end

  def purge_old_indexed_works!
    skope = self
    elastic_ids = skope.search_works("",{}, {return_records: false, force_elastic:true}).collect{|a| a.id.to_i}
    db_ids = skope.works_including_child_works.select(:id).collect(&:id)

    elastic_ids_to_remove = elastic_ids - db_ids

    elastic_search = skope.works.__elasticsearch__
    index_name = elastic_search.index_name
    document_type = elastic_search.document_type

    elastic_ids_to_remove.collect do |elastic_id_to_remove|
      elastic_search.client.delete({
        index: index_name,
        type:  document_type,
        id:    elastic_id_to_remove
      })
    end
  end

  def attach_sub_collection_ownables_when_base
    if persisted? && self.changes.keys.include?("base")
      child_collection_ids = expand_with_child_collections.select{|c| c.id unless (c.base? || c == self)}.compact

      Theme.where(collection_id: child_collection_ids).each do | instance |
        instance.collection = self
        unless instance.save
          if instance.errors.details[:name] && instance.errors.details[:name][0][:error] == :taken
            existing_instance = Theme.where(name: instance.name, collection_id: self.id).first
            existing_instance.works += instance.works
            existing_instance.save

            instance.hide = true
            instance.save
          else
            raise CollectionBaseError.new("Base transition cannot be performed for collection with id #{self.id}")
          end
        end
      end

      Cluster.where(collection_id: child_collection_ids).each do | instance |
        instance.collection = self
        unless instance.save
          if instance.errors.details[:name] && instance.errors.details[:name][0][:error] == :taken
            existing_instance = Cluster.where(name: instance.name, collection_id: self.id).first

            instance.works.update_all(cluster_id: existing_instance.id)
            instance.destroy
          else
            raise CollectionBaseError.new("Base transition cannot be performed for collection with id #{self.id}")
          end
        end
      end
    end
  end

  private

  def cache_all_collection_name_extended!
    UpdateCacheWorker.perform_async(self.name, :collection_name_extended)
  end

  class << Collection
    def all_plus_a_fake_super_collection
      [FakeSuperCollection.new] + self.all
    end

    def for_user user
      return self.not_system.with_root_parent if (user.admin? && !user.admin_with_favorites?)
      self.joins(:users).where(users: {id: user.id}).not_system
    end

    def for_user_expanded user
      return self.not_system if (user.admin? && !user.admin_with_favorites?)
      self.joins(:users).where(users: {id: user.id}).not_system.expand_with_child_collections
    end

    def for_user_or_if_no_user_all user=nil
      user ? self.for_user(user) : self.where.not(root: true)
    end

    def last_updated
      order(:updated_at).last
    end
  end
end
