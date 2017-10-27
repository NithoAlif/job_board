RSpec.describe JobBoard::Database do
  let(:data_host) { '127.0.0.1' }
  let(:data_port) { '1336' }
  let(:data_user) { 'thisuser' }
  let(:data_pass) { 'changeme' }
  let(:data_db) { 'onboarding' }
  let(:invalid_data) { '1234' }
  
  let(:default_db) { JobBoard::Database.new }

  let(:valid_db) do
    JobBoard::Database.new(
      data_host, data_port,
      data_user, data_pass, data_db
    )
  end

  let(:invalid_db) do
    JobBoard::Database.new(
      invalid_data, invalid_data, invalid_data,
      invalid_data, invalid_data
    )
  end

  let(:env_db) do
    ENV['MYSQL_HOST'] = data_host
    ENV['MYSQL_PORT'] = data_port
    ENV['MYSQL_USER'] = data_user
    ENV['MYSQL_PASS'] = data_pass
    ENV['MYSQL_DB'] = data_db
    JobBoard::Database.new
  end

  describe '.initialize' do
    it 'succeed with reading .env file' do
      expect(default_db.client).to be_an_instance_of(Mysql2::Client)
    end

    it 'succeed with proper parameter' do
      expect(valid_db.client).to be_an_instance_of(Mysql2::Client)
    end

    it 'succeed with reading environment variable' do
      expect(env_db.client).to be_an_instance_of(Mysql2::Client)
    end

    it 'failed due to invalid data' do
      expect(JobBoard::Database.new(host=invalid_data).client).to eql(nil)
      expect(JobBoard::Database.new(port=invalid_data).client).to eql(nil)
      expect(JobBoard::Database.new(user=invalid_data).client).to eql(nil)
      expect(JobBoard::Database.new(pass=invalid_data).client).to eql(nil)
      expect(JobBoard::Database.new(db=invalid_data).client).to eql(nil)
    end
  end
end