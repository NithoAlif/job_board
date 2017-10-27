require 'dotenv'
require 'mysql2'
require 'json'
require 'logger'

require "job_board/version"
require "job_board/database"
require "job_board/job"

module JobBoard
  def self.get_all
    @db = JobBoard::Database.new.client
    result = @db.query("SELECT * FROM jobs")
      return result.to_a
  end
end
