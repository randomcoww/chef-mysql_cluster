class ChefMysqlCluster
  class Resource
    class Ndb < Chef::Resource
      include MysqlHelper

      resource_name :mysql_cluster_ndb

      default_action :start
      allowed_actions :start, :enable, :restart, :stop

      property :options, Hash, default: {}
      property :bin_path, String, default: '/usr/sbin/ndbd'
      property :exec_command, String, default: lazy { "#{bin_path} #{ConfigGenerator.generate_from_hash(options)}" }
    end
  end
end
