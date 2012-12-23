require 'rubygems'
require 'phidgets-ffi'

puts "Library Version: #{Phidgets::FFI.library_version}"

br = Phidgets::Bridge.new

puts "Wait for PhidgetBridge to attached..."

#The following method runs when the PhidgetBridge is attached to the system
br.on_attach  do |device, obj|
  puts "Device attributes: #{device.attributes} attached"
  puts "Class: #{device.device_class}"
	puts "Id: #{device.id}"
	puts "Serial number: #{device.serial_number}"
	puts "Version: #{device.version}"
	puts "# Inputs: #{device.inputs.size}"

	device.inputs[0].enabled = true
	device.inputs[0].gain = Phidgets::FFI::BridgeGains[:gain_32]
	device.data_rate = 64

	sleep 1

	puts "Enabled: #{device.inputs[0].enabled}"
	puts "Gain: #{device.inputs[0].gain}"
end

br.on_detach  do |device, obj|
	puts "#{device.attributes.inspect} detached"
end

br.on_error do |device, obj, code, description|
	puts "Error #{code}: #{description}"
end

br.on_bridge_data do |device, inputs, value|
 	puts "Bridge #{inputs.index}'s value changed to #{value}"
end

sleep 5

if(br.attached?)
	5.times do
		begin
			puts "Bridge Value[0]: #{br.inputs[0].bridge_value}"
		rescue Phidgets::Error::UnknownVal => e
			puts "Exception caught: #{e.message}"
		end
		sleep 0.5
	end
end

sleep 5
br.close
