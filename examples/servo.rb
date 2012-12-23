require 'rubygems'
require 'phidgets-ffi'

puts "Library Version: #{Phidgets::FFI.library_version}"

servo = Phidgets::Servo.new

puts "Wait for PhidgetServo to attached..."

#The following method runs when the PhidgetServo is attached to the system
servo.on_attach  do |device, obj|
  puts "Device attributes: #{device.attributes} attached"
  puts "Class: #{device.device_class}"
	puts "Id: #{device.id}"
	puts "Serial number: #{device.serial_number}"
	puts "Version: #{device.version}"
	puts "# Servos: #{device.servos.size}"

	device.servos[0].engaged = true
	device.servos[0].type = Phidgets::FFI::ServoType[:default]
	puts "Setting servo parameters: #{device.servos[0].set_servo_parameters(600, 2000, 120)}"
	sleep 1
end

servo.on_detach  do |device, obj|
	puts "#{device.attributes.inspect} detached"
end

servo.on_error do |device, obj, code, description|
	puts "Error #{code}: #{description}"
end

servo.on_position_change do |device, motor, position|
	puts "Moving servo #{motor.index} to #{position}"
end

sleep 5

if servo.attached?
	max = servo.servos[0].position_max
	3.times do
		servo.servos[0].position = rand(max)
		sleep 1
	end
end

servo.servos[0].engaged = false
sleep 1
servo.close
