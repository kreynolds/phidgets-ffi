require 'rubygems'
require 'phidgets-ffi'

puts "Library Version: #{Phidgets::FFI.library_version}"

en = Phidgets::Encoder.new
	  
puts "Wait for PhidgetEncoder to attached..."

#The following method runs when the PhidgetEncoder is attached to the system
en.on_attach  do |device, obj|
	 
    puts "Device attributes: #{device.attributes} attached"
    puts "Class: #{device.device_class}"
	puts "Id: #{device.id}"
	puts "Serial number: #{device.serial_number}"
	puts "Version: #{device.version}"
	puts "# Digital Inputs: #{en.inputs.size}"  
	puts "# Encoders: #{device.encoders.size}"

    begin
		en.encoders[0].enabled = true  #some encoders do not support the enable feature
	rescue Phidgets::Error::Unsupported => e
		puts "Exception caught: #{e.message}"
	end
	
	sleep 1

	en.encoders[0].position = 200
	
	begin
		puts "Index Position: #{en.encoders[0].index_position}"
	 rescue Phidgets::Error::UnknownVal => e
		puts "Exception caught: #{e.message}"
	end
	
	puts "Position: #{en.encoders[0].position}"
end
	 
en.on_detach  do |device, obj|
	puts "#{device.attributes.inspect} detached"
end

en.on_error do |device, obj, code, description|
	puts "Error #{code}: #{description}"
end

en.on_input_change do |device, input, state, obj|
    puts "Input #{input.index}'s state has changed to #{state}"
end

en.on_position_change do |device, encoder, time, position_change, obj|

	puts "Encoder #{encoder.index} -- Position: #{device.encoders[encoder.index].position} -- Relative Change: #{position_change} -- Elapsed Time: #{time}"
end

sleep 10

en.close
