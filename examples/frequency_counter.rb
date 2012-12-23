require 'rubygems'
require 'phidgets-ffi'

puts "Library Version: #{Phidgets::FFI.library_version}"

fc = Phidgets::FrequencyCounter.new

puts "Wait for PhidgetFrequncyCounter to attached..."

#The following method runs when the PhidgetFrequencyCounter is attached to the system
fc.on_attach  do |device, obj|
  puts "Device attributes: #{device.attributes} attached"
  puts "Class: #{device.device_class}"
	puts "Id: #{device.id}"
	puts "Serial number: #{device.serial_number}"
	puts "Version: #{device.version}"
	puts "# Inputs: #{device.inputs.size}"

	device.inputs[0].enabled = true

	device.inputs[0].filter_type = Phidgets::FFI::FrequencyCounterFilterTypes[:filter_type_zero_crossing]

	device.inputs[0].timeout = 100018

	sleep 1

	puts "Enabled: #{device.inputs[0].enabled}"
	puts "Filter Type: #{device.inputs[0].filter_type}"
	puts "Timeout: #{device.inputs[0].timeout}"

end

fc.on_detach  do |device, obj|
	puts "#{device.attributes.inspect} detached"
end

fc.on_error do |device, obj, code, description|
	puts "Error #{code}: #{description}"
end

fc.on_count do |device, input, time, count, obj|
 	puts "Channel #{input.index}: #{count} pulses in #{time} microseconds"
end

sleep 5

if(fc.attached?)
	5.times do
		begin
			puts "Frequency[0]: #{fc.inputs[0].frequency}"
			puts "Total count: #{fc.inputs[0].total_count}"
			puts "Total time: #{fc.inputs[0].total_time} microseconds"
			puts ''
		rescue Phidgets::Error::UnknownVal => e
			puts "Exception caught: #{e.message}"
		end
		sleep 0.5
	end
end

sleep 1
fc.close
