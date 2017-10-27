RSpec.describe JobBoard do
  it "has a version number" do
    expect(JobBoard::VERSION).not_to be nil
  end
 
  describe '.get_all' do
    it 'succeed retrieving all job listing' do
      # setup
      job = JobBoard::Job.new
      inserted_data = ['1','2','3','4','5']
      job.create(*inserted_data)
      all_data = JobBoard.get_all
      
      expect(all_data).to be_an_instance_of(Array)
      expect(all_data.last['category']).to eql(inserted_data[0])
      expect(all_data.last['position']).to eql(inserted_data[1])
      expect(all_data.last['company']).to eql(inserted_data[2])
      expect(all_data.last['post']).to eql(inserted_data[3])
      expect(all_data.last['email']).to eql(inserted_data[4])

      # teardown
      job.delete
    end
  end
end
