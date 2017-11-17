require 'json'
require 'httparty'
require 'facebook/messenger'
include Facebook::Messenger
# NOTE: ENV variables should be set directly in terminal for testing on localhost
 

# Subcribe bot to your page
Facebook::Messenger::Subscriptions.subscribe(access_token: ENV["ACCESS_TOKEN"])

# API_URL = 'https://maps.googleapis.com/maps/api/geocode/json?address='
 
Bot.on :message do |message|
    message.typing_on
    message.reply(text: "Received '#{message.inspect}' from #{message.sender}")
end

# Bot.on :message do |message|
#   message.reply(text: 'Hello!')
#   puts "Received '#{message.inspect}' from #{message.sender}"
# end

# Bot.on :message do |message|
#     puts "Received '#{message.inspect}' from #{message.sender}" # debug purposes
#     parsed_response = get_parsed_response(API_URL, message.text) # talk to Google API
#     message.typing_on # trick user into thinking we type something with our fingers, HA HA HA
#     coord = extract_coordinates(parsed_response) # we have a separate method for that
#     message.reply(text: "Latitude: #{coord['lat']}, Longitude: #{coord['lng']}")
# end

# def get_parsed_response(url, query)
#     # Use HTTParty gem to make a get request 
#     response = HTTParty.get(url + query)
#     # Parse the resulting JSON so it's now a Ruby Hash
#     parsed = JSON.parse(response.body)
#     # Return nil if we got no results from the API.  
#     parsed['status'] != 'ZERO_RESULTS' ? parsed : nil
# end

# # Look inside the hash to find coordinates 
# def extract_coordinates(parsed)
#     parsed['results'].first['geometry']['location']
# end