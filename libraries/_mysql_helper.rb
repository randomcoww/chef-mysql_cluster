module MysqlHelper

  class ConfigGenerator
    def self.generate_from_hash(c)
      g = new
      g.ini_sections(c).join($/)
    end

    def self.parse_options(options)
      options.map do |k, v|
        case v
        when String,Integer
          "--#{[k, v].join('=')}"
        when NilClass
          "--#{k}"
        end
      end.join(' ')
    end

    def ini_sections(c, res=[])
      c.each_pair do |k, v|
        case v
        when Array
          v.each do |j|
            ini_sections({k => j}, res)
          end

        when Hash
          res << "[#{k}]"
          ini_options(v, res)
          res << ""
        end
      end
      res
    end

    def ini_options(c, res=[])
      c.each_pair do |k, v|
        case v
        when Array
          v.each do |j|
            ini_options({k => j}, res)
          end

        when Hash
          next

        when NilClass
          res << k

        else
          res << [k, v].join('=')
        end
      end
    end
  end


  ## load mysql gem with lazy require
  class Client
    def initialize(opts)
      require 'mysql2'

      @client = Mysql2::Client.new(opts)
    rescue Mysql2::Error
      Chef::Log.info("Failed to connect to server")
    end

    def query(sql)
      @client.query(sql)
    end
  end
end
