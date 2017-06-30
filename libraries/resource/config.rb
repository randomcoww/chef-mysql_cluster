class ChefMysqlCluster
  class Resource
    class Config < Chef::Resource
      include MysqlConfig

      resource_name :mysql_cluster_config

      default_action :create
      allowed_actions :create, :delete

      property :exists, [TrueClass, FalseClass]
      property :config, Hash
      property :content, String, default: lazy { mysql_generate_config(config) }
      property :path, String
    end
  end
end
