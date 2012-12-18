require 'rubygems'
require 'phidgets-ffi'

puts "Library Version: #{Phidgets::FFI.library_version}"

rfid = Phidgets::RFID.new

puts "Wait for PhidgetRFID to attached..."
	  
#The following method runs when the PhidgetRFID is attached to the system
rfid.on_attach  do |device, obj|
	 
    puts "Device attributes: #{device.attributes} attached"
    puts "Class: #{device.device_class}"
	puts "Id: #{device.id}"
	puts "Serial number: #{device.serial_number}"
	puts "# Digital Outputs: #{device.outputs.size}"
	
	rfid.outputs[0].state = true
	puts rfid.outputs.inspect
	
	rfid.antenna = true
	rfid.led = true
	sleep 1
end
	 
rfid.on_detach  do |device, obj|
	puts "#{device.attributes.inspect} detached"
end

rfid.on_error do |device, obj, code, description|
	puts "Error #{code}: #{description}"
end

rfid.on_output_change do |device, output, state, obj|
	puts "Output #{output.index}'s state has changed to #{state}"
end
	
rfid.on_tag	do |device, tag, obj|
	puts "Tag #{tag} detected"
end

rfid.on_tag_lost do |device, tag, obj|
	puts "Tag #{tag} removed"
end

puts "Please insert a tag to read read ..."		

sleep 3
	
if(rfid.attached?)
	sleep 1

	begin
		puts "Tag present: #{rfid.tag_present}"
		puts "Last tag: #{rfid.last_tag}"
		puts "Last tag proto: #{rfid.last_tag_protocol}"
		
		# Example for writing to a tag:
		#rfid.write("Some tag..", Phidgets::FFI::RFIDTagProtocol[:PhidgetTAG])
		
	rescue Phidgets::Error::UnknownVal => e
		puts "Exception caught: #{e.message}"
	end
end

rfid.close