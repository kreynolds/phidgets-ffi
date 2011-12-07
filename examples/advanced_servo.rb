require 'rubygems'
require 'phidgets-ffi'

puts "Library Version: #{Phidgets::FFI.library_version}"

adv = Phidgets::AdvancedServo.new
	  
puts "Wait for PhidgetAdvancedServo to attached..."

#The following method runs when the PhidgetAdvancedServo is attached to the system
adv.on_attach  do |device, obj|
	 
    puts "Device attributes: #{device.attributes} attached"
    puts "Class: #{device.device_class}"
	puts "Id: #{device.id}"
	puts "Serial number: #{device.serial_number}"
	puts "Version: #{device.version}"
	puts "# Servos: #{device.advanced_servos.size}"

	device.advanced_servos[0].engaged = true
	sleep 1  #allow time for engaged to be set before event ends

end
	 
adv.on_detach  do |device, obj|
	puts "#{device.attributes.inspect} detached"
end

adv.on_error do |device, obj, code, description|
	puts "Error #{code}: #{description}"
end

adv.on_velocity_change do |device, servo, velocity, obj|
    puts "Servo #{servo.index}'s velocity has changed to #{velocity}"
end

adv.on_position_change do |device, servo, position, obj|
    puts "Servo #{servo.index}'s position has changed to #{position}"
end

adv.on_current_change do |device, servo, current, obj|
    puts "Servo #{servo.index}'s current has changed to #{current}"
end

sleep 3

if(adv.attached?)

	max = adv.advanced_servos[0].position_max
	3.times do
		adv.advanced_servos[0].position = rand(max)
		sleep 0.5
	end

	puts "Setting servo parameters: #{adv.advanced_servos[0].set_servo_parameters(600, 2000, 120, 1500)}"
	
	puts "Acceleration: #{adv.advanced_servos[0].acceleration}"
	puts "Acceleration min: #{adv.advanced_servos[0].acceleration_min}"
	puts "Acceleration max: #{adv.advanced_servos[0].acceleration_max}"
	puts "Current: #{adv.advanced_servos[0].current}"
	puts "Speed ramp: #{adv.advanced_servos[0].speed_ramping}"
	puts "Stopped: #{adv.advanced_servos[0].stopped}"
	puts "Type: #{adv.advanced_servos[0].type}"
	puts "Velocity: #{adv.advanced_servos[0].velocity}"
	sleep 2

	adv.advanced_servos[0].velocity_limit = 200
	sleep 1
	puts "Velocity limit: #{adv.advanced_servos[0].velocity_limit}"
	puts "Velocity max: #{adv.advanced_servos[0].velocity_max}"
	puts "Velocity min: #{adv.advanced_servos[0].velocity_min}"

	adv.advanced_servos[0].acceleration = 89
	adv.advanced_servos[0].position_max = 160
	adv.advanced_servos[0].position_min = 5
	adv.advanced_servos[0].speed_ramping = true
	adv.advanced_servos[0].type = Phidgets::FFI::AdvancedServoType[:default]
	puts "Type: #{adv.advanced_servos[0].type}"

	begin	
		puts "Position: #{adv.advanced_servos[0].position}" #An error is raised when the position is unknown
	rescue Phidgets::Error::UnknownVal => e
		puts "Exception caught: #{e.message}"
	end

	puts "Position max: #{adv.advanced_servos[0].position_max}"
	puts "Position min: #{adv.advanced_servos[0].position_min}"

end

sleep 2
adv.advanced_servos[0].engaged = false
sleep 1
adv.close
