require 'mysql2'
require 'dotenv'

require "job_board/version"

module JobBoard
  class << self
    attr_accessor :mysql_host, :mysql_port, :mysql_user, :mysql_pass, :mysql_db    
    attr_accessor :db
  end

  def self.configure(host=nil, port=nil, user=nil, pass=nil, db=nil)
    # Load .env, system/user set environment take precedence
    Dotenv.load('.env')
    @mysql_host = host || ENV['MYSQL_HOST']
    @mysql_port = port || ENV['MYSQL_PORT']
    @mysql_user = user || ENV['MYSQL_USER']
    @mysql_pass = pass || ENV['MYSQL_PASS']
    @mysql_db = db || ENV['MYSQL_db']

    # Connect to database
    begin
      @db = Mysql2::Client.new(
        :host => @mysql_host,
        :port => @mysql_port,
        :username => @mysql_user,
        :password => @mysql_pass,
        :database => @mysql_db
        )
    rescue
      puts "Could not connect to database, please check the settings"
    else
      puts "Connection successful"
    end
  end

  def self.reset_configuration
    # Close database connection
    @db.close

    # Reset configuration value
    @mysql_host = nil
    @mysql_port = nil
    @mysql_user = nil
    @mysql_pass = nil
    @mysql_db = nil
  end

  def self.print_configuration
    puts @mysql_host
    puts @mysql_port
    puts @mysql_user
    puts @mysql_pass
    puts @mysql_db  
  end
end
