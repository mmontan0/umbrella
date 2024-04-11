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

raw_weather_data=HTTP.get(pirate_weather_url)

parsed_weather_data=JSON.parse(raw_weather_data)

currently_hash=parsed_weather_data.fetch("currently")

current_temp=currently_hash.fetch("temperature")

current_summary=currently_hash.fetch("summary")

pp "Today #{current_location} is #{current_summary} with a temperature of #{current_temp}F"
