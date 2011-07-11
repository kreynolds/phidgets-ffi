require 'rubygems'
require 'phidgets-ffi'

puts "Library Version: #{Phidgets::FFI.library_version}"
Phidgets::ServoController.new(-1) do |controller|
  puts "Servos attached: #{controller.servos.size}"
  servo = controller.servos[0]
  puts "Current Type: #{servo.type}"
  puts "Default Min/Max: #{servo.min}/#{servo.max}"
  puts "Device Name: #{controller.name}"
  puts "Device Type: #{controller.type}"
  puts "Device SN: #{controller.serial_number}"
  puts "Device Version: #{controller.version}"

  puts "Device Label: #{controller.label}"
  controller.on_change do |servo, position, data|
    print "Moving servo #{servo.index} to #{position}\n"
  end
  
  controller.on_attach do |obj, data|
    print "Attached #{obj.type}"
  end

  max = servo.max
  10.times do
    servo.position = rand(max)
    sleep 0.5
  end
  servo.engaged = false
end

