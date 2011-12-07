require 'rubygems'
require 'phidgets-ffi'

puts "Library Version: #{Phidgets::FFI.library_version}"

led = Phidgets::LED.new

puts "Wait for PhidgetLED to attached..."
	  
#The following method runs when the PhidgetLED is attached to the system
led.on_attach  do |device, obj|
	 
    puts "Device attributes: #{device.attributes} attached"
    puts "Class: #{device.device_class}"
	puts "Id: #{device.id}"
	puts "Serial number: #{device.serial_number}"
	puts "Version: #{device.version}"
	puts "# LEDs: #{device.leds.size}"
	
	device.leds.each do |i|
		device.leds[i].brightness = 50
	end
 
end
	 
led.on_detach  do |device, obj|
	puts "#{device.attributes.inspect} detached"
end

led.on_error do |device, obj, code, description|
	puts "Error #{code}: #{description}"
end

sleep 5

led.close