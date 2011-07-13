require 'rubygems'
require 'phidgets-ffi'

puts "Library Version: #{Phidgets::FFI.library_version}"
Phidgets::InterfaceKit.new(-1) do |ifkit|
  puts "Device attributes: #{ifkit.attributes.inspect}"

  ifkit.on_output_change do |output, state, obj|
    print "Output #{output.index} has changed to #{state}\n"
  end

  ifkit.wait_for_attachment
  ifkit.outputs[0].state = true
  ifkit.outputs[0].state = false
  
  puts ifkit.sensors[0].inspect
  ifkit.sensors[0].rate = 64
  ifkit.sensors[0].trigger = 20
  puts ifkit.sensors[0].inspect
end