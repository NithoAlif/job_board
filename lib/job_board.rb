require 'dotenv'
require 'mysql2'
require 'json'

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
    @mysql_db = db || ENV['MYSQL_DB']

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
      return 1
    else
      puts "Connection successful"
      return 0
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

  def self.create(category, position, company, post, email)
    begin
      statement = @db.prepare(
        "INSERT INTO jobs (category, position, company, post, email)
        VALUES (?, ?, ?, ?, ?)"
        )
      result = statement.execute(
        category,
        position,
        company,
        post,
        email
        )
    rescue
      puts "Could not create new listing, please check the database connection"
      return 1
    else
      puts "Job succesfully listed"
      return 0
    end
  end

  def self.get_all
    begin
      result = @db.query("SELECT * FROM jobs")
    rescue
      puts "Could not get job listing, please check the database connection"
      return 1
    else
      return result
    end
  end

  def self.get(id)
    begin
      statement = @db.prepare("SELECT * FROM jobs WHERE id = ?")
      result = statement.execute(id)
    rescue
      puts "Could not get job listing, please check the database connection"
      return 1
    else
      result.each do |row|
        return row
      end
    end
  end

  def self.update(id, category, position, company, post, email)
    begin
      statement = @db.prepare(
        "UPDATE jobs
        SET category=?, position=?, company=?, post=?, email=?
        WHERE id = ?")
      result = statement.execute(
        category,
        position,
        company,
        post,
        email,
        id)

      if statement.affected_rows != 1
        puts "Could not find job listing with id = ".concat(id.to_s)
        return 2
      end
    rescue 
      puts "Could not update job listing, please check the database connection"
      return 1
    else
      puts "Job succesfully updated"
      return 0
    end
  end

  def self.delete(id)
    begin
      statement = @db.prepare("DELETE FROM jobs WHERE id = ?")
      result = statement.execute(id)

      if statement.affected_rows != 1
        puts "Could not find job listing with id = ".concat(id.to_s)
        return 2
      end
    rescue 
      puts "Could not delete job listing, please check the database connection"
      return 1
    else
      puts "Job succesfully deleted"
      return 0
    end
  end
end
