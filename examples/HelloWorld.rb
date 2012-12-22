=begin
  Phidget Hello World Program for all devices
  (c) Phidgets 2012
=end

require 'rubygems'
require 'phidgets-ffi'

manager = Phidgets::Manager.new

#Determine if there are devices already attached to the computer
manager.devices.size.times do |i|
	puts "Hello Device #{Phidgets::Common.name(manager.devices[i])}, Serial Number: #{Phidgets::Common.serial_number(manager.devices[i])}"
end

# ========== Event Handling Functions ==========
#The attach event will detect any devices attached AFTER the program is run.
manager.on_attach do |device_ptr, obj|
	puts "Hello Device #{Phidgets::Common.name(device_ptr)}, Serial Number: #{Phidgets::Common.serial_number(device_ptr)}"
end

manager.on_detach do |device_ptr, obj|
	puts "Goodbye Device #{Phidgets::Common.name(device_ptr)}, Serial Number: #{Phidgets::Common.serial_number(device_ptr)}"
end

manager.on_error do |device, obj, code, description|
  puts "Error - code #{code}, description #{description}"
end

puts 'Phidget Simple Playground (plug and unplug devices)'
puts 'Please Enter to end anytime...'

gets.chomp

puts 'Closing...'
manager.close
