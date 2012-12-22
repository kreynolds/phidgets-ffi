require 'rubygems'
require 'phidgets-ffi'

puts "Library Version: #{Phidgets::FFI.library_version}"

lcd = Phidgets::TextLCD.new

puts "Wait for PhidgetTextLCD to attached..."

#The following method runs when the PhidgetTextLCD is attached to the system
lcd.on_attach  do |device, obj|
  puts "Device attributes: #{device.attributes} attached"
  puts "Class: #{device.device_class}"
	puts "Id: #{device.id}"
	puts "Serial number: #{device.serial_number}"
	puts "Version: #{device.version}"
	puts "# Screens: #{device.screens.size}"

	puts "Device attributes: #{device.attributes} attached"
    puts "Class: #{device.device_class}"
	puts "Id: #{device.id}"
	puts "Serial number: #{device.serial_number}"
	puts "Version: #{device.version}"
	puts "# screens: #{device.screens.size}"

	if(lcd.id.to_s == "textlcd_adapter") #the TextLCD Adapter supports screen_size and initialize_screen
		device.screens[0].screen_size = Phidgets::FFI::TextLCDScreenSizes[:screen_size_2x8]
		device.screens[0].initialize_screen
		device.screens[1].initialize_screen
	end

	sleep 1

	device.screens[0].contrast = 100
	device.screens[0].back_light = true
	device.screens[0].cursor  = true
	device.screens[0].cursor_blink  = true
	sleep 1

	puts device.screens[0].inspect
end

lcd.on_detach  do |device, obj|
	puts "#{device.attributes.inspect} detached"
end

lcd.on_error do |device, obj, code, description|
	puts "Error #{code}: #{description}"
end

sleep 2

if(lcd.attached?)
	sleep 3

	puts "Screen 0, # rows: #{lcd.screens[0].rows.size}"
	puts "Screen 0, # columns: #{lcd.screens[0].rows[0].maximum_length}"

	puts 'Displaying row number'
	lcd.screens[0].rows.size.times do |i|
		lcd.screens[0].rows[i].display_string = "Row #{i}"
	end

	sleep 3

	#Switching screens if supported
	if(lcd.id.to_s == "textlcd_adapter")
		puts 'Switching to the next screen'
		lcd.screens[1].screen_size = Phidgets::FFI::TextLCDScreenSizes[:screen_size_2x16]
		lcd.screens[1].cursor_blink  = true
		lcd.screens[1].rows[0].display_string = "Screen #2"
	end

	sleep 3

	#Storing 7 custom characters as well as displaying them.
	puts 'Displaying custom characters'
	lcd.custom_characters[0].set_custom_character(949247, 536)
	lcd.custom_characters[1].set_custom_character(1015791, 17180)
	lcd.custom_characters[2].set_custom_character(1048039, 549790)
	lcd.custom_characters[3].set_custom_character(1031395, 816095)
	lcd.custom_characters[4].set_custom_character(498785, 949247)
	lcd.custom_characters[5].set_custom_character(232480, 1015791)
	lcd.custom_characters[6].set_custom_character(99328, 1048039)
	lcd.screens[0].rows[0].display_string = "#{lcd.custom_characters[0].string_code}#{lcd.custom_characters[1].string_code}#{lcd.custom_characters[2].string_code}#{lcd.custom_characters[3].string_code}#{lcd.custom_characters[4].string_code}#{lcd.custom_characters[5].string_code}#{lcd.custom_characters[6].string_code}"

	sleep 3

	#Display 'Hello' with ASCII Code(hexadecimal)
	puts 'Displaying characters in ASCII code'
	lcd.screens[0].rows[1].display_string = "\x48\x65\x6c\x6c\x6f"


	#Displays a single character for a specific column for a row
	lcd.screens[0].rows[1].display_character(5, 0x21)  #hex code for exclamation mark in ASCII
end

sleep 5
lcd.close
