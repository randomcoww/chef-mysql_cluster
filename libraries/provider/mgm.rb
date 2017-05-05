class ChefMysqlCluster
  class Provider
    class Mgm < Chef::Provider
      provides :mysql_cluster_mgm, os: "linux"

      use_inline_resources

      def load_current_resource
        @current_resource = ChefMysqlCluster::Resource::Mgm.new(new_resource.name)
        current_resource
      end

      def action_start
        mysql_cluster_mgm_service.run_action(:create)
        mysql_cluster_mgm_service.run_action(:start)
      end

      def action_enable
        mysql_cluster_mgm_service.run_action(:create)
        mysql_cluster_mgm_service.run_action(:enable)
      end

      def action_restart
        mysql_cluster_mgm_service.run_action(:create)
        mysql_cluster_mgm_service.run_action(:restart)
      end

      def action_stop
        mysql_cluster_mgm_service.run_action(:create)
        mysql_cluster_mgm_service.run_action(:stop)
      end

      private

      def mysql_cluster_mgm_service
        @mysql_cluster_mgm_service ||= Chef::Resource::SystemdUnit.new('ndb_mgmd.service', run_context).tap do |r|
          r.content ({
            'Unit' => {
              'Description' => 'MySQL Cluster Management Server',
              'After' => 'network.target'
            },
            'Install' => {
              'WantedBy' => 'multi-user.target'
            },
            'Service' => {
              'RestartSec' => 5,
              'Type' => 'forking',
              'ExecStart' => new_resource.exec_command,
              'Restart' => 'on-failure'
            }
          })
        end
      end
    end
  end
end
