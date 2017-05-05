class ChefMysqlCluster
  class Resource
    class Sql < Chef::Resource
      resource_name :mysql_cluster_sql

      default_action :query
      allowed_actions :query

      property :options, Hash, default: {}
      property :queries, Array, default: []
      property :timeout, Integer, default: 120
      property :ignore_errors, [TrueClass, FalseClass], default: false
    end
  end
end
