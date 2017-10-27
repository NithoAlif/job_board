module JobBoard
  class Job
    attr_accessor :id
    attr_accessor :category, :position, :company, :post, :email

    def initialize
      # Setup database connection
      @db = JobBoard::Database.new.client

      # Setup logging
      file = File.open('log/operation.log', File::WRONLY | File::APPEND | File::CREAT)
      @logger = Logger.new(file)

      # Assign initial value
      @category = ''
      @position = ''
      @company = ''
      @post = ''
      @email = ''
    end


    def create(category:, position:, company:, post:, email:)
      statement = @db.prepare(
        "INSERT INTO jobs (category, position, company, post, email)
        VALUES (?, ?, ?, ?, ?)"
        )
      result = statement.execute(
        category, position,
        company, post, email
        )

      @id = @db.last_id
      @category = category
      @position = position
      @company = company
      @post = post
      @email = email
    end


    def fetch(id=@id)
      @id = id
      if !id.nil?
        statement = @db.prepare("SELECT * FROM jobs WHERE id = ?")
        result = statement.execute(@id)

        if result.count == 0
          @logger.info "Could not find job listing with id = ".concat(id.to_s)
        else
          data = result.to_a.first
          @category = data['category']
          @position = data['position']
          @company = data['company']
          @post = data['post']
          @email = data['email']
        end
      
      else
        @logger.error "Id cannot be empty. Please create/fetch first"        
      end
    end


    def update(
      category: @category, position: @position,
      company: @company, post: @post, email: @email)

      if !@id.nil?
        @category = category
        @position = position
        @company = company
        @post = post
        @email = email

        statement = @db.prepare(
          "UPDATE jobs
          SET category=?, position=?, company=?, post=?, email=?
          WHERE id = ?")
        result = statement.execute(
          category, position, company,
          post, email, @id)

          if statement.affected_rows != 1
            @logger.info "Could not find job listing with id = ".concat(@id.to_s)
          end
      else
        @logger.error "Id cannot be empty. Please create/fetch first"
      end
    end


    def delete
      if !@id.nil?
        statement = @db.prepare("DELETE FROM jobs WHERE id = ?")
        result = statement.execute(id)
  
        if statement.affected_rows != 1
          @logger.info "Could not find job listing with id = ".concat(id.to_s)
        else
          @id = nil
          @category = ''
          @position = ''
          @company = ''
          @post = ''
          @email = ''
        end
      else
        @logger.error "Id cannot be empty. Please create/fetch first"
      end
    end


    def print_var
      puts @id, @category, @position, @company, @post, @email
    end
    
  end
end