RSpec.describe JobBoard::Job do

  let(:data_category) { 'Test' }
  let(:data_position) { 'SRE' }
  let(:data_company) { 'Google' }
  let(:data_post) { 'This is just a test' }
  let(:data_email) { 'fake.email@mail.com' }
  let(:modified_data) { 'Another test' }

  before do
    @job = JobBoard::Job.new
    @job.create(
      data_category,
      data_position,
      data_company,
      data_post,
      data_email
    )
  end

  after do
    @job.delete
  end


  describe '.create' do
    it 'succeed creating a job listing' do
      expect(@job.id).not_to be nil
      expect(@job.category).to eql(data_category)
      expect(@job.position).to eql(data_position)
      expect(@job.company).to eql(data_company)
      expect(@job.post).to eql(data_post)
      expect(@job.email).to eql(data_email)
    end

    it 'failed to be invoked due to insufficient argument' do
      expect{JobBoard::Job.new.create}.to raise_error(ArgumentError)
    end
  end


  describe '.get' do
    it 'succeed retrieving a job listing' do
      expect(@job.get(@job.id)).to eql(0)
      expect(@job.id).to be > 0
      expect(@job.category).to eql(data_category)
      expect(@job.position).to eql(data_position)
      expect(@job.company).to eql(data_company)
      expect(@job.post).to eql(data_post)
      expect(@job.email).to eql(data_email)
    end

    it 'failed to be invoked due to empty id' do
      expect(JobBoard::Job.new.get).to eq(-1)
    end

    it 'failed to be invoked due to invalid id' do
      expect(JobBoard::Job.new.get(-1)).to eql(-2)
    end
  end


  describe '.update' do
    it 'succeed updating a job listing' do      
      return_code = @job.update(
        category: modified_data,
        position: modified_data,
        company: modified_data,
        post: modified_data,
        email: modified_data
        )
      expect(return_code).to eql(0)
      expect(@job.id).to eql(@job.id)
      expect(@job.category).to eql(modified_data)
      expect(@job.position).to eql(modified_data)
      expect(@job.company).to eql(modified_data)
      expect(@job.post).to eql(modified_data)
      expect(@job.email).to eql(modified_data)
    end

    it 'failed to be invoked due to empty id' do
      expect(JobBoard::Job.new.update).to eq(-1)
    end
  end

  describe '.delete' do
    it 'succeed deleting a job listing' do
      return_code = @job.delete
      expect(return_code).to eql(0)
      expect(@job.id).to be nil
    end

    it 'failed to be invoked due to empty id' do
      expect(JobBoard::Job.new.delete).to eq(-1)
    end

  end

end