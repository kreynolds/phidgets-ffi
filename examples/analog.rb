require 'rubygems'
require 'phidgets-ffi'

puts "Library Version: #{Phidgets::FFI.library_version}"

an = Phidgets::Analog.new
	  
puts "Wait for PhidgetAnalog to attached..."
	  
#The following method runs when the PhidgetAnalog is attached to the system
an.on_attach  do |device, obj|
	 
    puts "Device attributes: #{device.attributes} attached"
    puts "Class: #{device.device_class}"
	puts "Id: #{device.id}"
	puts "Serial number: #{device.serial_number}"
	puts "Version: #{device.version}"
	puts "# Outputs: #{device.outputs.size}"

	puts "Voltage min: #{device.outputs[0].voltage_min}"
	puts "Voltage max: #{device.outputs[0].voltage_max}"
	  
	device.outputs[0].enabled = true
	sleep 1
	device.outputs[0].voltage = 2.2
	  
	sleep 3

	device.outputs[0].enabled = false													
        sleep 1
end
	 
an.on_detach  do |device, obj|
	puts "#{device.attributes.inspect} detached"
end

an.on_error do |device, obj, code, description|
	puts "Error #{code}: #{description}"
end

sleep 5

an.close
