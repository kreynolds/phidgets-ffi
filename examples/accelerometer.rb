require 'rubygems'
require 'phidgets-ffi'

puts "Library Version: #{Phidgets::FFI.library_version}"

accel = Phidgets::Accelerometer.new 

puts "Wait for PhidgetAccelerometer to attached..."
	  
#The following method runs when the PhidgetAccelerometer is attached to the system
accel.on_attach  do |device, obj|
	 
    puts "Device attributes: #{device.attributes} attached"
    puts "Class: #{device.device_class}"
	puts "Id: #{device.id}"
	puts "Serial number: #{device.serial_number}"
	puts "Version: #{device.version}"
	puts "# Axes: #{device.axes.size}"

	puts device.axes[0].inspect
	puts "Accleration[0]: #{device.axes[0].acceleration}"
	puts "Acceleration min[0]: #{device.axes[0].acceleration_min}"
	puts "Acceleration max[0]: #{device.axes[0].acceleration_max}"
end
	 
accel.on_detach  do |device, obj|
	puts "#{device.attributes.inspect} detached"
end

accel.on_error do |device, obj, code, description|
	puts "Error #{code}: #{description}"
end

accel.on_acceleration_change do |device, axis, value|
 	puts "Axis #{axis.index}'s acceleration has changed to #{value}"
end 

sleep 10
accel.close
