require 'rubygems'
require 'phidgets-ffi'

puts "Library Version: #{Phidgets::FFI.library_version}"

ir = Phidgets::IR.new

puts "Wait for PhidgetIR to attached..."

#The following method runs when the PhidgetIR is attached to the system
ir.on_attach  do |device, obj|
  puts "Device attributes: #{device.attributes} attached"
  puts "Class: #{device.device_class}"
	puts "Id: #{device.id}"
	puts "Serial number: #{device.serial_number}"
	puts "Version: #{device.version}"

	#example of sending RAW Data - this was captured from an Apple remote Volume UP command
	volume_up_raw_data = [
		9040,   4590,    540,    630,    550,   1740,    550,   1750,    550,   1740,
     550,    620,    550,   1750,    550,   1740,    550,   1750,    550,   1740,
     550,   1740,    560,   1740,    540,    630,    550,    620,    550,    620,
     540,    630,    550,   1750,    550,   1740,    560,   1740,    550,    620,
     550,   1740,    550,    620,    550,    620,    560,    610,    550,    620,
     550,   1750,    550,   1740,    550,    620,    550,   1740,    550,   1750,
     550,    620,    550,    620,    550,    620,    540]

	5.times do
		puts 'Transmiting raw data ...'
		device.transmit_raw(volume_up_raw_data, 67, 38000, 33, 110000)
		sleep 0.2
	end
end

ir.on_detach  do |device, obj|
	puts "#{device.attributes.inspect} detached"
end

ir.on_error do |device, obj, code, description|
	puts "Error #{code}: #{description}"
end

ir.on_code do |device, data, data_length, bit_count, repeat, obj|
 	puts "Code #{data} received, length: #{data_length}, bit count: #{bit_count}, repeat: #{repeat}"
end

ir.on_learn do |device, data, data_length, code_info, obj|
		print "\n-------------------Learned Code---------------------\n"

		puts "Code: #{data}"
		puts "Data length: #{data_length}"
		puts "Bit count: #{code_info[:bit_count]}"
		puts "Encoding: #{code_info[:encoding]}"
		puts "Length: #{code_info[:length]}"
		puts "Gap: #{code_info[:gap]}"
		puts "Trail: #{code_info[:trail]}"
		puts "Header: #{code_info[:header][0]}, #{code_info[:header][1]}"
		puts "One: #{code_info[:one][0]}, #{code_info[:one][1]}"
		puts "Zero: #{code_info[:zero][0]}, #{code_info[:zero][1]}"
		puts "Min repeat: #{code_info[:min_repeat]}"

		printf 'Toggle mask: '
		16.times do |i|
			print "#{code_info[:toggle_mask][i]}, "
		end

		puts ''

		puts "Carrier frequency: #{code_info[:carrier_frequency]}"
		print "Duty cycle: #{code_info[:duty_cycle]} \n\n"

end

ir.on_raw_data do |device, raw_data, data_length, obj|
	print "Raw data: "

	data_length.times do |i|
		print "#{raw_data[i]}, "
	end

	puts ''
end

puts "Please transmit a code now ..."
sleep 10

if(ir.attached?)
	apple_volume_down = ["77", "E1", "B0", "F0"]
	apple_volume_code_info = Phidgets::IR::IR_code_info.new
	apple_volume_code_info[:bit_count] = 32
	apple_volume_code_info[:encoding] = Phidgets::FFI::IREncoding[:encoding_space]
	apple_volume_code_info[:length] = Phidgets::FFI::IRLength[:length_constant]
	apple_volume_code_info[:gap] = 232
	apple_volume_code_info[:trail] = 432
	apple_volume_code_info[:header][0] = 9080
	apple_volume_code_info[:header][1] = 4604
	apple_volume_code_info[:one][0] = 550
	apple_volume_code_info[:one][1] = 1753
	apple_volume_code_info[:zero][0] = 550
	apple_volume_code_info[:zero][1] = 623
	apple_volume_code_info[:min_repeat] = 0
	apple_volume_code_info[:carrier_frequency] = 38000
	apple_volume_code_info[:duty_cycle] = 50

	begin
		5.times do
			puts 'Transmitting data ...'
			ir.transmit apple_volume_down, apple_volume_code_info
			sleep 0.2
		end
	rescue Phidgets::Error::Timeout => e
		puts "Exception caught: #{e.message}"
	end

	5.times do
		begin
			puts ''
			raw_data, raw_data_length = ir.read_raw_data

			print "Last raw data: "
			raw_data_length.times do |i|
				print "#{raw_data[i]},"
			end

			puts ''
			puts "Data length: #{raw_data_length}"

			puts ''
			data, data_length, bit_count = ir.last_code

			print 'Last code: '
			print "#{data}"
			puts ''
			puts "Data length: #{data_length}"
			puts "Bit count: #{bit_count}"

			puts ''
			sleep 0.2
			puts '----------------------------------------------------'

			puts 'Transmitting the last code that was received'
			ir.transmit data, apple_volume_code_info
		rescue Phidgets::Error::UnknownVal => e
			puts "Exception caught: #{e.message}"
		end
	end
end

sleep 1
ir.close
