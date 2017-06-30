module MysqlConfig

  def mysql_generate_config(c)
    ini_sections(c).join($/)
  end

  def mysql_parse_options(options)
    options.map do |k, v|
      case v
      when String,Integer
        "--#{[k, v].join('=')}"
      when NilClass
        "--#{k}"
      end
    end.join(' ')
  end


  private

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


  class Client
    def initialize(timeout, opts)
      require 'mysql2'

      Timeout::timeout(timeout) {
        while true
          begin
            @client = Mysql2::Client.new(opts)
            return
          rescue Mysql2::Error
            Chef::Log.info("Waiting #{timeout} seconds for hosts to come up...")
          end
          sleep 1
        end
      }
    end

    def query(sql, ignore_errors=false)
      begin
        @client.query(sql)
      rescue Mysql2::Error => e
        raise e unless ignore_errors
      end
    end
  end
end
