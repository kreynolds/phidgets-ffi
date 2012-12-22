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

	device.current_limit = Phidgets::FFI::LEDCurrentLimit[:current_limit_20mA]
	device.voltage = Phidgets::FFI::LEDVoltage[:voltage_3_9V]
end

led.on_detach  do |device, obj|
	puts "#{device.attributes.inspect} detached"
end

led.on_error do |device, obj, code, description|
	puts "Error #{code}: #{description}"
end

sleep 1

if(led.attached?)
	led.leds.each do |i|
		i.current_limit = 20
		i.brightness = 50
	end

	sleep 1
	led.leds.each do |i|
		i.brightness = 100
	end

	sleep 1
	led.leds.each do |i|
		i.current_limit = 2
	end
end

led.close
