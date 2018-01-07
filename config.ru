require_relative './init.rb'
require 'faye'

if ENV['RACK_ENV']=='production'

  require_relative 'bot'
  require 'facebook/messenger'

  # run both Sinatra and facebook-messenger on /webhook
  map("/webhook") do
    use Faye::RackAdapter, :mount => '/faye', :timeout => 25
    run ThxSeafood::Api.freeze.app
    run Facebook::Messenger::Server
  end
end

# run regular sinatra for other paths (in case you ever need it)
use Faye::RackAdapter, :mount => '/faye', :timeout => 25
run ThxSeafood::Api.freeze.app