require 'rubygems'
require 'phidgets-ffi'

puts "Library Version: #{Phidgets::FFI.library_version}"

spatial = Phidgets::Spatial.new

puts "Wait for PhidgetSpatial to attached..."

#The following method runs when the PhidgetSpatial is attached to the system
spatial.on_attach  do |device, obj|
  puts "Device attributes: #{device.attributes} attached"
  puts "Class: #{device.device_class}"
	puts "Id: #{device.id}"
	puts "Serial number: #{device.serial_number}"
	puts "Version: #{device.version}"
	puts "# Accelerometer Axes: #{device.accelerometer_axes.size}"
	puts "# Compass Axes: #{device.compass_axes.size}"
	puts "# Gyro Axes: #{device.gyro_axes.size}"

	device.accelerometer_axes.size.times do |i|
		puts "Acceleration Axis[#{i}]: #{device.accelerometer_axes[i].acceleration}"
		puts "Acceleration Axis[#{i}] Min: #{device.accelerometer_axes[i].acceleration_min}"
		puts "Acceleration Axis[#{i}] Max: #{device.accelerometer_axes[i].acceleration_max}"
	end

	device.compass_axes.size.times do |i|
		#Even when there is a compass chip, sometimes there won't be valid data in the event.
		begin
			puts "Compass Axis[#{i}]: #{device.compass_axes[i].magnetic_field}"
		rescue Phidgets::Error::UnknownVal => e
			puts "Exception caught: #{e.message}"
		end

		puts "Compass Axis[#{i}] Min: #{device.compass_axes[i].magnetic_field_min}"
		puts "Compass Axis[#{i}] Max: #{device.compass_axes[i].magnetic_field_max}"
	end

	device.gyro_axes.size.times do |i|
		puts "Gyro Axis[#{i}]: #{device.gyro_axes[i].angular_rate}"
		puts "Gyro Axis[#{i}] Min: #{device.gyro_axes[i].angular_rate_min}"
		puts "Gyro Axis[#{i}] Max: #{device.gyro_axes[i].angular_rate_max}"
	end
end

spatial.on_detach  do |device, obj|
	puts "#{device.attributes.inspect} detached"
end

spatial.on_error do |device, obj, code, description|
	puts "Error #{code}: #{description}"
end

spatial.on_spatial_data do |device, acceleration, magnetic_field, angular_rate|
	if acceleration.size > 0
		puts "Acceleration: #{acceleration[0]}, #{acceleration[1]}, #{acceleration[2]}"
	end

	if magnetic_field.size > 0
  	puts "Magnetic field: #{magnetic_field[0]}, #{magnetic_field[1]}, #{magnetic_field[2]}"
  end

	if angular_rate.size > 0
  	puts "Angular rate: #{angular_rate[0]}, #{angular_rate[1]}, #{angular_rate[2]}"
  end
end

sleep 2

if spatial.attached?
	sleep 1
end

sleep 10
