require 'rubygems'
require 'phidgets-ffi'

Phidgets::Manager.new do |manager|

	manager.devices.size.times do |i|
		puts "Attached: #{Phidgets::Common.name(manager.devices[i])}, serial number: #{Phidgets::Common.serial_number(manager.devices[i])}"
	end
	puts ''

	manager.on_attach do |device_ptr, obj|
	puts "Attaching #{Phidgets::Common.name(device_ptr)}, serial number: #{Phidgets::Common.serial_number(device_ptr)}"

	end

	manager.on_detach do |device_ptr, obj|
	puts "Detaching #{Phidgets::Common.name(device_ptr)}, serial number: #{Phidgets::Common.serial_number(device_ptr)}"

	end

	puts "You have 20 seconds to plug/unplug USB devices and watch the callbacks execute"
	sleep 20
end
