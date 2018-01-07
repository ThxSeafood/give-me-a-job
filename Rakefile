# frozen_string_literal: true

require 'rake/testtask'

task :default do
  puts `rake -T`
end

# Configuration only -- not for direct calls
task :config do
  require_relative 'config/environment.rb' # load config info
  @app = ThxSeafood::Api
  @config = @app.config
end

desc 'update api results'
task :update do
  sh 'ruby spec/fixtures/api_info.rb'
end

desc 'run tests once'
Rake::TestTask.new(:spec) do |t|
  t.pattern = 'spec/*_spec.rb'
  t.warning = false
end

desc 'Keep rerunning tests upon changes'
task :respec do
  puts 'REMEMBER: need to run `rake run:[dev|test]:worker` in another process'
  sh "rerun -c 'rake spec' --ignore 'coverage/*'"
end

desc 'Run application console (pry)'
task :console do
  sh 'pry -r ./spec/test_load_all'
end

namespace :api do
  namespace :run do
    desc 'Rerun the API server in development mode'
    task :development do
      puts 'REMEMBER: need to run `rake run:dev:worker` in another process'
      sh "rerun -c 'rackup -p 3030'"
    end

    desc 'Rerun the API server in test mode'
    task :test do
      puts 'REMEMBER: need to run `rake run:test:worker` in another process'
      sh "rerun -c 'RACK_ENV=test rackup -p 3000' --ignore 'coverage/*'"
    end

    desc 'Run the API server to test the client app'
    task :app_test do
      puts 'REMEMBER: need to run `rake worker:run:app_test` in another process'
      sh "rerun -c 'RACK_ENV=test rackup -p 3000'"
    end

  end
end

namespace :worker do
  namespace :run do
    desc 'Run the background cloning worker in development mode'
    task :development => :config do
      sh 'RACK_ENV=development bundle exec shoryuken -r ./workers/find_hot_jobs_worker.rb -C ./workers/shoryuken_dev.yml'
    end

    desc 'Run the background cloning worker in testing mode'
    task :test => :config do
      sh 'RACK_ENV=test bundle exec shoryuken -r ./workers/find_hot_jobs_worker.rb -C ./workers/shoryuken_test.yml'
    end

    desc 'Run the background cloning worker in testing mode'
    task :app_test => :config do
      sh 'RACK_ENV=app_test bundle exec shoryuken -r ./workers/find_hot_jobs_worker.rb -C ./workers/shoryuken_test.yml'
    end

    desc 'Run the background cloning worker in production mode'
    task :production => :config do
      sh 'RACK_ENV=production bundle exec shoryuken -r ./workers/find_hot_jobs_worker.rb -C ./workers/shoryuken.yml'
    end
  end
end

namespace :vcr do
  desc 'Delete cassette fixtures'
  task :delete do
    sh 'rm spec/fixtures/cassettes/*.yml' do |ok, _|
      puts(ok ? 'Cassettes deleted' : 'No cassettes found')
    end
  end
end

namespace :quality do
  CODE = '**/*.rb'

  desc 'Run all quality checks'
  task all: %i[rubocop reek flog]

  desc 'Run Rubocop quality checks'
  task :rubocop do
    sh "rubocop #{CODE}"
  end

  desc 'Run Reek quality checks'
  task :reek do
    sh "reek #{CODE}"
  end

  desc 'Run Flog quality checks'
  task :flog do
    sh "flog #{CODE}"
  end
end

namespace :queue do
  require 'aws-sdk-sqs'

  desc "Create SQS queue for Shoryuken"
  task :create => :config do
    ENV["AWS_ACCESS_KEY_ID"] = @config.AWS_ACCESS_KEY_ID
    ENV["AWS_SECRET_ACCESS_KEY"] = @config.AWS_SECRET_ACCESS_KEY
    sqs = Aws::SQS::Client.new(region: @config.AWS_REGION)

    begin
      queue = sqs.create_queue(
        queue_name: @config.CLONE_QUEUE,
        attributes: {
          FifoQueue: 'true',
          ContentBasedDeduplication: 'true'
        }
      )

      q_url = sqs.get_queue_url(queue_name: @config.CLONE_QUEUE)
      puts "Queue created:"
      puts "Name: #{@config.CLONE_QUEUE}"
      puts "Region: #{@config.AWS_REGION}"
      puts "URL: #{q_url.queue_url}"
      puts "Environment: #{@app.environment}"
    rescue => e
      puts "Error creating queue: #{e}"
    end
  end

  desc "Purge messages in SQS queue for Shoryuken"
  task :purge => :config do
    ENV["AWS_ACCESS_KEY_ID"] = @config.AWS_ACCESS_KEY_ID
    ENV["AWS_SECRET_ACCESS_KEY"] = @config.AWS_SECRET_ACCESS_KEY
    sqs = Aws::SQS::Client.new(region: @config.AWS_REGION)

    begin
      queue = sqs.purge_queue(queue_url: @config.CLONE_QUEUE_URL)
      puts "Queue #{@config.CLONE_QUEUE} purged"
    rescue => e
      puts "Error purging queue: #{e}"
    end
  end
end

namespace :db do
  require_relative 'config/environment.rb' # load config info
  require 'sequel' # TODO: remove after create orm

  Sequel.extension :migration
  app = ThxSeafood::Api

  desc 'Run migrations'
  task :migrate do
    puts "Migrating #{app.environment} database to latest"
    Sequel::Migrator.run(app.DB, 'infrastructure/database/migrations')
  end

  desc 'Drop all tables'
  task :drop do
    require_relative 'config/environment.rb'
    # drop according to dependencies
    app.DB.drop_table :jobs
    app.DB.drop_table :hots
    app.DB.drop_table :schema_info
  end

  desc 'Reset all database tables'
  task reset: [:drop, :migrate]

  desc 'Delete dev or test database file'
  task :wipe do
    if app.environment == :production
      puts 'Cannot wipe production database!'
      return
    end

    FileUtils.rm(app.config.DB_FILENAME)
    puts "Deleted #{app.config.DB_FILENAME}"
  end
end
