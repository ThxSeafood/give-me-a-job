# frozen_string_literal: true

require_relative 'load_all'

require 'econfig'
require 'shoryuken'
# require 'concurrent'
require 'json'

# Shoryuken worker class to clone repos in parallel
class FindHotJobsWorker
  extend Econfig::Shortcut
  Econfig.env = ENV['RACK_ENV'] || 'development'
  Econfig.root = File.expand_path('..', File.dirname(__FILE__))

  Shoryuken.sqs_client = Aws::SQS::Client.new(
    access_key_id: config.AWS_ACCESS_KEY_ID,
    secret_access_key: config.AWS_SECRET_ACCESS_KEY,
    region: config.AWS_REGION
  )

  include Shoryuken::Worker
  shoryuken_options queue: config.CLONE_QUEUE_URL, auto_delete: true


  



  def perform(_sqs_msg, worker_request)

    ThxSeafood::Api.DB[:hots].delete
    done_count = 0
    
    request = ThxSeafood::FindHotJobsRequestRepresenter.new(OpenStruct.new).from_json worker_request
    topnum = request.topnum             # Integer
    channel_id = request.channel_id     # Integer

    citys = ["台北", "新北", "桃園", "新竹", "台中", "台南", "高雄"].freeze

    citys.each{ |city|
      
      puts "processing: #{city}\n"
      # hot_jobs = ThxSeafood::Repository::For[ThxSeafood::Entity::Job].find_hot_jobs_by_city_using_regexp(topnum, city)
      hot_jobs = ThxSeafood::Repository::For[ThxSeafood::Entity::Job].all[0..topnum-1]
      
      hot_jobs.each{ |job|
        ThxSeafood::Repository::For[ThxSeafood::Entity::Hot].create(job, city)
      }

      # hot_jobs_json = ThxSeafood::JobsRepresenter.new(ThxSeafood::JobsResult.new(hot_jobs)).to_json
      puts "city #{city} done\n"    
      update_progress(channel_id, city)

      done_count = done_count + 1
      puts("progress: #{done_count}/7\n")      
    }
  end


  private

  PROGRESS = {
    "台北" => 14,
    "新北" => 28,
    "桃園" => 42,
    "新竹" => 60,
    "台中" => 74,
    "台南" => 88,
    "高雄" => 100
  }.freeze

  def update_progress(channel_id, city)
    percent = progress(city).to_s
    message = percent
    publish(channel_id, message)
  end

  def publish(channel, message)
    puts "Posting message: #{message}"
    HTTP.headers(content_type: 'application/json')
        .post(
          "#{FindHotJobsWorker.config.API_URL}/faye",
          body: {
            channel: "/#{channel}",
            data: message
          }.to_json
        )
  end

  def progress(city)
    PROGRESS[city]
  end


end
