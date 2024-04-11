require "http"
require "json"

puts "Please write your location"
current_location= gets.chomp
puts "Checking the weather at #{current_location}"

gmaps_key=ENV.fetch("GMAPS_KEY")

gmaps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{current_location}&key=#{gmaps_key}"

raw_gmaps_data = HTTP.get(gmaps_url)

parsed_gmaps_data = JSON.parse(raw_gmaps_data)

results_array = parsed_gmaps_data.fetch("results")

first_result_hash= results_array.at(0)

geometry_hash= first_result_hash.fetch("geometry")

location_hash=geometry_hash.fetch("location")

latitude=location_hash.fetch("lat")

longitude=location_hash.fetch("lng")

pp "Your location is lat: #{latitude}, lon: #{longitude}"

pirate_weather_key= ENV.fetch("PIRATE_WEATHER_KEY")

pirate_weather_url= "https://api.pirateweather.net/forecast/#{pirate_weather_key}/#{latitude},#{longitude}"
