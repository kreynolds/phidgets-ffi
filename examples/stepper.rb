require 'rubygems'
require 'phidgets-ffi'

puts "Library Version: #{Phidgets::FFI.library_version}"

st = Phidgets::Stepper.new

puts "Wait for PhidgetStepper to attached..."

#The following method runs when the PhidgetStepper is attached to the system
st.on_attach  do |device, obj|
  puts "Device attributes: #{device.attributes} attached"
  puts "Class: #{device.device_class}"
	puts "Id: #{device.id}"
	puts "Serial number: #{device.serial_number}"
	puts "Version: #{device.version}"
	puts "# Inputs: #{device.inputs.size}"
	puts "# Steppers: #{device.steppers.size}"

	puts "Digital input[0] state: #{device.inputs[0].state}"

	device.steppers[0].engaged = true

	device.steppers[0].acceleration = (device.steppers[0].acceleration_min) * 2
	device.steppers[0].velocity_limit = (device.steppers[0].velocity_max) / 2

	begin
		puts "Stepper 0: Current Position: #{device.steppers[0].current_position}"
	rescue Phidgets::Error::UnknownVal => e
		puts "Exception caught: #{e.message}"
	end
end

st.on_detach  do |device, obj|
	puts "#{device.attributes.inspect} detached"
end

st.on_error do |device, obj, code, description|
	puts "Error #{code}: #{description}"
end

st.on_input_change do |device, input, state, obj|
	print "Input #{input.index}'s state has changed to #{state}\n"
end

st.on_velocity_change do |device, stepper, velocity, obj|
	puts "Stepper #{stepper.index}'s velocity has changed to #{velocity}"
end

st.on_position_change do |device, stepper, position, obj|
	puts "Stepper #{stepper.index}'s position has changed to #{position}"
end

st.on_current_change do |device, stepper, current, obj|
	puts "Stepper #{stepper.index}'s current has changed to #{current}"
end

sleep 5

if(st.attached?)
	sleep 2

	puts 'Moving to position 200'
	st.steppers[0].target_position = 200
	sleep 2

	puts 'Moving to position 1200'
	st.steppers[0].target_position = 1200
	sleep 2

	puts 'Moving to position 0'
	st.steppers[0].target_position = 0
	sleep 2

	if (st.steppers[0].stopped == true)
		puts 'Stepper 0 has stopped'
	else
		puts 'Stepper 0 has not stopped yet'
	end

	st.steppers[0].engaged = false
end

sleep 1
st.close
