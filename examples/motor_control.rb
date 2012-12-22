require 'rubygems'
require 'phidgets-ffi'

puts "Library Version: #{Phidgets::FFI.library_version}"

mc = Phidgets::MotorControl.new

puts "Wait for PhidgetMotorControl to attached..."

mc.on_attach  do |device, obj|
	puts 'attach event'
  puts "Device attributes: #{device.attributes} attached"
  puts "Class: #{device.device_class}"
	puts "Id: #{device.id}"
	puts "Serial number: #{device.serial_number}"
	puts "Version: #{device.version}"
	puts "# Motors: #{device.motors.size}"
	puts "# Inputs: #{device.inputs.size}"
	puts "# Encoders: #{device.encoders.size}"
	puts "# Sensors: #{device.sensors.size}"
end

mc.on_detach  do |device, obj|
	puts "#{device.attributes.inspect} detached"
end

mc.on_error do |device, obj, code, description|
	#puts "Error #{code}: #{description}"
end


mc.on_input_change do |device, input, state|
 	puts "Digital Input #{input.index}'s state changed to #{state}"
end

=begin
mc.on_sensor_update do |device, sensor, value|
 	puts "Analog Sensor #{sensor.index}'s value is #{value}"
end
=end

mc.on_velocity_change do |device, motor, velocity|
 	puts "Motor #{motor.index}'s velocity changed to #{velocity}"
end

mc.on_current_change do |device, motor, current|
 	puts "Motor #{motor.index}'s current changed to #{current}"
end

=begin
mc.on_current_update do |device, motor, current|
 	puts "Motor #{motor.index}'s current is #{current}"
end
=end

=begin
mc.on_back_emf_update do |device, motor, voltage|
 	puts "Motor #{motor.index}'s back EMF is #{voltage}"
end
=end

mc.on_position_change do |device, encoder, time, position|
 	puts "Encoder #{encoder.index}'s position changed to #{position} in #{time}"
end

=begin
mc.on_position_update do |device, encoder, position|
 	puts "Encoder #{encoder.index}'s position is #{position}"
end
=end

sleep 5

if(mc.attached?)
	if(mc.id.to_s == "motor_control_1motor")
		mc.ratiometric = true

		puts "Digital input: #{mc.inputs.inspect}"

		puts "Encoder: #{mc.encoders.inspect}"

		puts "Analog sensor: #{mc.sensors[0].inspect}"
		puts "Analog sensor: #{mc.sensors[1].inspect}"

		puts "Motor current: #{mc.motors[0].current}"

		mc.motors[0].acceleration = (mc.motors[0].acceleration_max)/2
		mc.motors[0].back_emf_sensing = true
	end

	puts "Motor acceleration min: #{mc.motors[0].acceleration_min}"
	puts "Motor acceleration max: #{mc.motors[0].acceleration_max}"

	sleep 1
	100.times do |i|
		mc.motors[0].velocity = i
		sleep 0.1
	end

	mc.motors[0].velocity = 0

	sleep 2
end
