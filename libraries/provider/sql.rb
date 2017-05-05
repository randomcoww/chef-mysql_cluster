class ChefMysqlCluster
  class Provider
    class Sql < Chef::Provider
      include MysqlConfig

      provides :mysql_cluster_sql, os: "linux"

      def load_current_resource
        @current_resource = ChefMysqlCluster::Resource::Sql.new(new_resource.name)
        current_resource
      end

      def action_query
        new_resource.queries.each do |e|
          mysql_client.query(e, new_resource.ignore_errors)
        end
      end

      private

      def mysql_client
        @mysql_client ||= Client.new(new_resource.timeout, new_resource.options)
      end
    end
  end
end
