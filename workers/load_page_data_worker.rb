# frozen_string_literal: true

require_relative 'load_all'

require 'econfig'
require 'shoryuken'
require 'concurrent'

# Shoryuken worker class to clone repos in parallel
class LoadPageDataWorker
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


  @@done_count = 0

  def perform(_sqs_msg, worker_request)
    request = ThxSeafood::LoadDataRequestRepresenter.new(OpenStruct.new).from_json worker_request
    page = request.page
    page_num = request.page_num
    keywords = request.keywords
    # offset = request.offset 

    # page_start = 1 + 20 * (offset-1)
    # page_end = page_start + 19
    
    # if page_end > page_num
    #   page_end = page_num
    # end

    # 這邊暫時先不用concurrent，因為會出現有些page的資料沒被存進DB的情況發生
    # (1..20).each{ |page|
    #   Concurrent::Promise.execute{
    #     puts "load page: #{page}\n"
    #     jobs = ThxSeafood::A104::JobMapper.new(ThxSeafood::A104::Api.new).load_several(keywords, page)
    #     stored_jobs = jobs.map{ |job| ThxSeafood::Repository::For[job.class].create(job) }
    #     puts "page #{page} done\n"
    #   }.value
    # }

    # puts(page_num)



    # (page_start..page_end).each{ |page|
      
    #   puts "load page: #{page}\n"
    #   jobs = ThxSeafood::A104::JobMapper.new(ThxSeafood::A104::Api.new).load_several(keywords, page)
    #   stored_jobs = jobs.map{ |job| ThxSeafood::Repository::For[job.class].create(job) }
    #   puts "page #{page} done\n"

    #   @@done_count = @@done_count+1
    #   puts("progress: #{@@done_count}/50\n")
    # }

    
      
    puts "load page: #{page}\n"
    jobs = ThxSeafood::A104::JobMapper.new(ThxSeafood::A104::Api.new).load_several(keywords, page)
    stored_jobs = jobs.map{ |job| ThxSeafood::Repository::For[job.class].create(job) }
    puts "page #{page} done\n"
    
  
    @@done_count = @@done_count+1
    puts("progress: #{@@done_count}/#{page_num}\n")
    
  
  
  end

end
