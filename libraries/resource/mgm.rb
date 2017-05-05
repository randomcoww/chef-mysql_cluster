class ChefMysqlCluster
  class Resource
    class Mgm < Chef::Resource
      include MysqlConfig

      resource_name :mysql_cluster_mgm

      default_action :start
      allowed_actions :start, :enable, :restart, :stop

      property :options, Hash, default: {}
      property :bin_path, String, default: '/usr/sbin/ndb_mgmd'
      property :exec_command, String, default: lazy { "#{bin_path} #{parse_options(options)}" }
    end
  end
end
