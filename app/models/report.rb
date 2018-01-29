class Report < ApplicationRecord
  serialize :schema, JSON

  def exec_query **params
    query_connection.select_all(query(**params))
  end

  def query **args
    args = args.with_indifferent_access
    arguments = (params || {}).map do |key, value|
      [key, quote(value['type'], (args[key] || parse_default_param(value['type'], value['default']) || raise))]
    end.to_h
    interpolated_source = source.gsub(/#\{(.+?)\}/) do
      arguments[$1]
    end
    "SELECT #{output.join(',')} #{interpolated_source}"
  end

  def source
    schema['source']
  end

  def params
    schema['params']
  end

  def output
    schema['output']
  end

  def default_params
    schema['params'].select{|_, v| v['default']}.map{|k, v| [k, parse_default_param(v['type'], v['default'])]}.to_h
  end

  def query_connection
    QueryConnection.connection
  end

  def quote type, value
    case type
    when 'report'
      value
    else
      query_connection.quote value
    end
  end

  def parse_default_param type, value
    case type
    when 'date'
      DateTime.parse(value)
    when 'datetime'
      DateTime.parse(value)
    when 'time'
      Time.parse(value)
    when 'report'
      "(#{Report.find(value.match(/Report#(\d+)/)[1]).query})"
    end
  end
end
