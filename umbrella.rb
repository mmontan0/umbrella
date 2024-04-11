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

minutely_hash=parsed_weather_data.fetch("minutely")

if minutely_hash
  next_hour_summary=minutely_hash.fetch("summary")
  puts "Next hour will be: #{next_hour_summary}"
end

hourly_hash=parsed_weather_data.fetch("hourly")

hourly_data_array=hourly_hash.fetch("data")

next_twelve_hours=hourly_data_array[1 ..12]

precip_threshold=0.10

any_precipitation= false

next_twelve_hours.each do |hour_hash|
  prec_probability=hour_hash.fetch("precipProbability")
  if prec_probability>precip_threshold
    any_precipitation=true
    precip_time=Time.at(hour_hash.fetch("time"))
    sec_next_rain=precip_time-Time.now
    hours_from_now=sec_next_rain/60/60

    puts "In #{hours_from_now.round} there is a #{prec_probability*100}% of precipitation"
  end
end

if any_precipitation=true
  pp "You might want to take an umbrella"
else
  pp "You don't need an Umbrella, enjoy the weather!"
end
