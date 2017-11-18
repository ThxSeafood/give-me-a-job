require_relative './init.rb'

if ENV['RACK_ENV']=='production'

  require_relative 'bot'
  require 'facebook/messenger'

  # run both Sinatra and facebook-messenger on /webhook
  map("/webhook") do
    run ThxSeafood::Api.freeze.app
    run Facebook::Messenger::Server
  end
end

# run regular sinatra for other paths (in case you ever need it)
run ThxSeafood::Api.freeze.app