require 'rubygems'
require 'phidgets-ffi'

puts "Library Version: #{Phidgets::FFI.library_version}"

ifkit = Phidgets::InterfaceKit.new

ifkit.on_attach  do |device, obj|
  puts "Device attributes: #{device.attributes} attached"
  puts "Class: #{device.device_class}"
	puts "Id: #{device.id}"
	puts "Serial number: #{device.serial_number}"
	puts "Version: #{device.version}"
	puts "# Digital inputs: #{device.inputs.size}"
	puts "# Digital outputs: #{device.outputs.size}"
	puts "# Analog inputs: #{device.sensors.size}"

	sleep 1

	if(device.sensors.size > 0)
		device.ratiometric = false
    device.sensors[0].data_rate = 64
		device.sensors[0].sensitivity = 15

		puts "Sensivity: #{device.sensors[0].sensitivity}"
		puts "Data rate: #{device.sensors[0].data_rate}"
		puts "Data rate max: #{device.sensors[0].data_rate_max}"
		puts "Data rate min: #{device.sensors[0].data_rate_min}"
		puts "Sensor value[0]: #{device.sensors[0].to_i}"
		puts "Raw sensor value[0]: #{device.sensors[0].raw_value}"

		device.outputs[0].state = true
		sleep 1 #allow time for digital output 0's state to be set
		puts "Is digital output 0's state on? ... #{device.outputs[0].on?}"
	end
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
ifkit.close
