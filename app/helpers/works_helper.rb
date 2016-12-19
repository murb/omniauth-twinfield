module WorksHelper
  # @params set [Hash] with object and counts
  def filter_checkboxes hash, field_name, base_scope = [:activerecord,:values,:work], reference = @selection_filter, options={}

    return "Geen verfijning mogelijk" if hash.nil?
    options = { render_count: false }.merge(options)
    str = ""
    i18n_scope = base_scope << field_name.to_sym
    hash = hash.sort{|a,b| a[1][:name] <=> b[1][:name]}
    hash.each do | former_pair |
      value = former_pair[0]
      data = former_pair[1]
      value_methods = value.methods
      check_box_value = (value_methods.include?(:id) ? value.id : value)
      checked =  reference[field_name] && ( reference[field_name].include?(check_box_value) || reference[field_name].include?(check_box_value.to_s) || (value == :not_set and reference[field_name].include?(nil)))

      str << label_tag do
        label_str = check_box_tag "filter[#{field_name}][]", check_box_value, checked
        if value_methods.include?(:name)
          label_str << data[:name]
        else
          label_str << I18n.t(value, scope: i18n_scope)
        end
        label_str << " (#{data[:count]})" if options[:render_count]
        label_str
      end
    end
    raw str
  end
end