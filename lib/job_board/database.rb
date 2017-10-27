module JobBoard
  class Database
    attr_accessor :client

    def initialize(host=nil, port=nil, user=nil, pass=nil, db=nil)
      # Setup logging
      file = File.open('log/database.log', File::WRONLY | File::APPEND | File::CREAT)
      @logger = Logger.new(file)

      # Load .env, system/user set environment take precedence
      Dotenv.load('.env')
      @mysql_host = host || ENV['MYSQL_HOST']
      @mysql_port = port || ENV['MYSQL_PORT']
      @mysql_user = user || ENV['MYSQL_USER']
      @mysql_pass = pass || ENV['MYSQL_PASS']
      @mysql_db = db || ENV['MYSQL_DB']
      connect()
    end


    def connect()
      # Connect to database
      begin
        @client = Mysql2::Client.new(
          :host => @mysql_host,
          :port => @mysql_port,
          :username => @mysql_user,
          :password => @mysql_pass,
          :database => @mysql_db
          )
      rescue
        @logger.error "Could not connect to database, please check the settings"
        return -1
      else
        @logger.info "Database connection established"   
        return 0     
      end
    end


    def configure(host=nil, port=nil, user=nil, pass=nil, db=nil)
      # Configure database connection
      @mysql_host = host
      @mysql_port = port
      @mysql_user = user
      @mysql_pass = pass
      @mysql_db = db

      connect()
    end


    def print_configuration
      puts @mysql_host, @mysql_port, @mysql_user, @mysql_pass, @mysql_db
    end
  end
end