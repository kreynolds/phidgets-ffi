require 'rubygems'
require 'phidgets-ffi'

puts "Library Version: #{Phidgets::FFI.library_version}"

gps = Phidgets::GPS.new

puts "Wait for PhidgetGPS to attached..."

#The following method runs when the PhidgetGPS is attached to the system
gps.on_attach  do |device, obj|
  puts "Device attributes: #{device.attributes} attached"
  puts "Class: #{device.device_class}"
	puts "Id: #{device.id}"
	puts "Serial number: #{device.serial_number}"
	puts "Version: #{device.version}"

	puts "Waiting for position fix status to be acquired"
end

gps.on_detach  do |device, obj|
	puts "#{device.attributes.inspect} detached"
end

gps.on_error do |device, obj, code, description|
	puts "Error #{code}: #{description}"
end

gps.on_position_fix_status_change do |device, fix_status, obj|
	puts "Position fix status changed to: #{fix_status}"
end

gps.on_position_change do |device, lat, long, alt, obj|
	puts "Latitude: #{lat} degrees, longitude: #{long} degrees, altitude: #{alt} m"
end

sleep 5

if(gps.attached?)
	5.times do
		begin
			puts "Latitude: #{gps.latitude} degrees"
		rescue Phidgets::Error::UnknownVal => e
			puts "Exception caught: #{e.message}"
		end

		begin
			puts "Longitude: #{gps.longitude} degrees"
		rescue Phidgets::Error::UnknownVal => e
			puts "Exception caught: #{e.message}"
		end

		begin
			puts "Altitude: #{gps.altitude} m"
		rescue Phidgets::Error::UnknownVal => e
			puts "Exception caught: #{e.message}"
		end

		begin
			puts "Heading: #{gps.heading} degrees"
		rescue Phidgets::Error::UnknownVal => e
			puts "Exception caught: #{e.message}"
		end

		begin
			puts "Velocity: #{gps.velocity} km/h"
		rescue Phidgets::Error::UnknownVal => e
			puts "Exception caught: #{e.message}"
		end

		begin
			puts "GPS Time(UTC): #{gps.time[:hours]}:#{gps.time[:minutes]}:#{gps.time[:seconds]}:#{gps.time[:milliseconds]}"
		rescue Phidgets::Error::UnknownVal => e
			puts "Exception caught: #{e.message}"
		end

		begin
			puts "GPS Date(UTC): #{gps.date[:month]}/#{gps.date[:day]}/#{gps.date[:year]}"
		rescue Phidgets::Error::UnknownVal => e
			puts "Exception caught: #{e.message}"
		end

		puts ''
		sleep 0.5
	end
end

sleep 50
gps.close
