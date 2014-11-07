require 'rubygems'
require 'phidgets-ffi'

puts "Library Version: #{Phidgets::FFI.library_version}"

puts "Wait for PhidgetInterfaceKit to attach..."

begin
Phidgets::InterfaceKit.new do |ifkit|
	puts "Device attributes: #{ifkit.attributes} attached"
	puts "Class: #{ifkit.device_class}"
	puts "Id: #{ifkit.id}"
	puts "Serial number: #{ifkit.serial_number}"
	puts "Version: #{ifkit.version}"
	puts "# Digital inputs: #{ifkit.inputs.size}"
	puts "# Digital outputs: #{ifkit.outputs.size}"
	puts "# Analog sensors: #{ifkit.sensors.size}"

	sleep 1

	if(ifkit.sensors.size > 0)
		ifkit.ratiometric = false
		ifkit.sensors[0].data_rate = 64
		ifkit.sensors[0].sensitivity = 15

		puts "Sensivity: #{ifkit.sensors[0].sensitivity}"
		puts "Data rate: #{ifkit.sensors[0].data_rate}"
		puts "Data rate max: #{ifkit.sensors[0].data_rate_max}"
		puts "Data rate min: #{ifkit.sensors[0].data_rate_min}"
		puts "Sensor value[0]: #{ifkit.sensors[0].to_i}"
		puts "Raw sensor value[0]: #{ifkit.sensors[0].raw_value}"

		ifkit.outputs[0].state = true
		sleep 1 #allow time for digital output 0's state to be set
		puts "Is digital output 0's state on? ... #{ifkit.outputs[0].on?}"
	end

	ifkit.on_detach  do |device, obj|
		puts "#{device.attributes.inspect} detached"
	end

	ifkit.on_error do |device, obj, code, description|
		puts "Error #{code}: #{description}"
	end

	ifkit.on_input_change do |device, input, state, obj|
		puts "Input #{input.index}'s state has changed to #{state}"
	end

	ifkit.on_output_change do |device, output, state, obj|
		puts "Output #{output.index}'s state has changed to #{state}"
	end

	ifkit.on_sensor_change do |device, input, value, obj|
		puts "Sensor #{input.index}'s value has changed to #{value}"
	end

	sleep 10
end
rescue Phidgets::Error::Timeout => e
  puts "Exception caught: #{e.message}"
end
