class Report < ApplicationRecord
  serialize :schema, JSON

  def exec_query **params
    QueryConnection.connection.select_all(query(**params))
  end

  def query **params
    regexp = /#\{(.+?)\}/
    params_in_source = schema['source'].scan(regexp).flatten
    source = schema['source'].gsub(regexp, '?')
    param_values = default_params.merge(params.with_indifferent_access).values_at(*params_in_source)
    output_columns = schema['output']
    ActiveRecord::Base.send(:sanitize_sql, ["SELECT #{output_columns.join(',')} #{source}", *param_values])
  end

  def default_params
    schema['params'].select{|_, v| v['default']}.map{|k, v| [k, parse_default_param(v['type'], v['default'])]}.to_h
  end

  def parse_default_param type, value
    case type
    when 'date'
      DateTime.parse(value)
    when 'datetime'
      DateTime.parse(value)
    when 'time'
      Time.parse(value)
    end
  end
end
