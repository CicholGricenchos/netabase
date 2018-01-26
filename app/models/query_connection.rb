class QueryConnection < ActiveRecord::Base
  establish_connection :for_query
end
