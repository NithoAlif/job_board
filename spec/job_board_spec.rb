RSpec.describe JobBoard do
  it "has a version number" do
    expect(JobBoard::VERSION).not_to be nil
  end
 
  context 'when testing database connection' do
    let(:host) { '127.0.0.1' }
    let(:port) { '1336' }
    let(:user) { 'thisuser' }
    let(:pass) { 'changeme' }
    let(:db) { 'onboarding' }
    let(:invalid_data) { '1234' }

    describe '.configure' do
      it 'succeed with proper parameter' do
        expect(JobBoard.configure(
          host,
          port,
          user,
          pass,
          db
        )).to eql(0)
      end

      it 'succeed with reading environment variable' do
        ENV['MYSQL_HOST'] = host
        ENV['MYSQL_PORT'] = port
        ENV['MYSQL_USER'] = user
        ENV['MYSQL_PASS'] = pass
        ENV['MYSQL_DB'] = db
        expect(JobBoard.configure()).to eql(0)
      end

      it 'succeed with reading .env file' do        
        expect(JobBoard.configure()).to eql(0)
      end

      it 'failed due to invalid host' do
        expect(JobBoard.configure(
          host: invalid_data
        )).to eql(-1)
      end

      it 'failed due to invalid port' do
        expect(JobBoard.configure(
          port: invalid_data
        )).to eql(-1)
      end

      it 'failed due to invalid user' do
        expect(JobBoard.configure(
          user: invalid_data
        )).to eql(-1)
      end

      it 'failed due to invalid password' do
        expect(JobBoard.configure(
          pass: invalid_data
        )).to eql(-1)
      end

      it 'failed due to invalid database' do
        expect(JobBoard.configure(
          host: invalid_data
        )).to eql(-1)
      end
    end

    describe ".reset_configuration" do
      it 'succeed clearing configuration' do
        invalid_db = '1234'
        expect(JobBoard.reset_configuration()).to eql(0)
      end
    end
  end


  context "when testing CRUD operations" do
    let(:category) { 'Test' }
    let(:position) { 'SRE' }
    let(:company) { 'Google' }
    let(:post) { 'This is just a test' }
    let(:email) { 'fake.email@mail.com' }
    let(:id) {
      JobBoard.create(
      category,
      position,
      company,
      post,
      email
    ) }

    before(:all) do
      JobBoard.configure
    end

    describe '.create' do
      it 'succeed creating a job listing' do
        expect(id).to be > 0
      end

      it 'failed to be invoked due to insufficient argument' do
        expect{JobBoard.create()}.to raise_error(ArgumentError)
      end
    end
    
    describe '.get' do
      it 'succeed retrieving a job listing' do
        data = JobBoard.get(id)
        expect(data['category']).to eql(category)
        expect(data['position']).to eql(position)
        expect(data['company']).to eql(company)
        expect(data['post']).to eql(post)
        expect(data['email']).to eql(email)
      end

      it 'failed to be invoked due to insufficient argument' do
        expect{JobBoard.get()}.to raise_error(ArgumentError)
      end

      it 'failed to be invoked due to invalid id' do
        expect(JobBoard.get(-1)).to eql(-2)
      end
    end

    describe '.update' do
      it 'succeed updating a job listing' do
        return_code = JobBoard.update(
          id,
          'this_category',
          'this_position',
          'this_company',
          'this_post',
          'this_email'
          )
        expect(return_code).to eql(0)
        data = JobBoard.get(id)
        expect(data['category']).to eql('this_category')
        expect(data['position']).to eql('this_position')
        expect(data['company']).to eql('this_company')
        expect(data['post']).to eql('this_post')
        expect(data['email']).to eql('this_email')
      end

      it 'failed to be invoked due to insufficient argument' do
        expect{JobBoard.update()}.to raise_error(ArgumentError)
      end

      it 'failed to be invoked due to invalid id' do
        expect(JobBoard.update(
          -1,
          category,
          position,
          company,
          post,
          email
          )).to eql(-2)
      end
    end

    describe '.delete' do
      it 'succeed deleting a job listing' do
        return_code = JobBoard.delete(id)
        expect(return_code).to eql(0)
        expect(JobBoard.get(id)).to eql(-2)
      end

      it 'failed to be invoked due to insufficient argument' do
        expect{JobBoard.delete()}.to raise_error(ArgumentError)
      end

      it 'failed to be invoked due to invalid id' do
        expect(JobBoard.delete(-1)).to eql(-2)
      end
    end

    describe '.get_all' do
      it 'succeed retrieving all job listing' do
        inserted_data = JobBoard.get(id)
        all_data = JobBoard.get_all
        expect(all_data).to be_an_instance_of(Array)
        expect(all_data.last['category']).to eql(inserted_data['category'])
        expect(all_data.last['position']).to eql(inserted_data['position'])
        expect(all_data.last['company']).to eql(inserted_data['company'])
        expect(all_data.last['post']).to eql(inserted_data['post'])
        expect(all_data.last['email']).to eql(inserted_data['email'])
      end
    end

  end

end
