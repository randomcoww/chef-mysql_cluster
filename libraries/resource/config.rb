class ChefMysqlCluster
  class Resource
    class Config < Chef::Resource
      include MysqlConfig

      resource_name :mysql_cluster_config

      default_action :create
      allowed_actions :create, :delete

      property :exists, [TrueClass, FalseClass]
      property :config, Hash
      property :content, String, default: lazy { to_ini(config) }
      property :path, String
    end
  end
end
