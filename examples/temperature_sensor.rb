require 'rubygems'
require 'phidgets-ffi'

puts "Library Version: #{Phidgets::FFI.library_version}"

temp = Phidgets::TemperatureSensor.new

puts "Wait for PhidgetTemperatureSensor to attached..."

#The following method runs when the PhidgetTemperatureSensor is attached to the system
temp.on_attach  do |device, obj|
  puts "Device attributes: #{device.attributes} attached"
  puts "Class: #{device.device_class}"
	puts "Id: #{device.id}"
	puts "Serial number: #{device.serial_number}"
	puts "Version: #{device.version}"
	puts "# Inputs: #{device.thermocouples.size}"

	begin
		puts temp.thermocouples[0].inspect
		temp.thermocouples[0].sensitivity = 0.02
		puts "Thermocouple Type: #{temp.thermocouples[0].type = Phidgets::FFI::TemperatureSensorThermocoupleTypes[:thermocouple_type_k_type]}"
		sleep 1
		puts "Temperature min: #{temp.thermocouples[0].temperature_min} degrees celcius"
		puts "Temperature max: #{temp.thermocouples[0].temperature_max} degrees celcius"
		puts "Temperature[0]: #{temp.thermocouples[0].temperature} degrees celcius"
		puts ''
	rescue Phidgets::Error::UnknownVal => e
		puts "Exception caught: #{e.message}"
	end
end

temp.on_detach  do |device, obj|
	puts "#{device.attributes.inspect} detached"
end

temp.on_error do |device, obj, code, description|
	puts "Error #{code}: #{description}"
end

temp.on_temperature_change do |device, input, temperature, obj|
 	puts "Input #{input.index}'s temperature changed to #{temperature}"
end

sleep 5

temp.close
