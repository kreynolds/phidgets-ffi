require 'rubygems'
require 'phidgets-ffi'

def device_name_for(device)
  ptr = FFI::MemoryPointer.new(:string, 1)
  CPhidget_getDeviceName(device, ptr)
  strPtr = ptr.get_pointer(0)
  strPtr.null? ? nil : strPtr.read_string
end

def serial_number_for(device)
  ptr = FFI::MemoryPointer.new(:int, 1)
  CPhidget_getSerialNumber(device, ptr)
  ptr.get_int(0)
end

include Phidgets::FFI

ifkit = FFI::MemoryPointer.new(:pointer, 1)
if !(res = CPhidgetInterfaceKit_create(ifkit))
  $stderr.puts "Unable to create interface kit"
  exit!(res)
else
  ifkit = ifkit.get_pointer(0)
end

AttachHandler = Proc.new { |device, ptr|
  print "Device attached: #{device_name_for(device)} (#{serial_number_for(device)})\n"
}
CPhidget_set_OnAttach_Handler(ifkit, AttachHandler, nil)

DetachHandler = Proc.new { |device, ptr|
  print "Device detached: #{device_name_for(device)} (#{serial_number_for(device)})\n"
}
CPhidget_set_OnDetach_Handler(ifkit, DetachHandler, nil)

InputChangeHandler = Proc.new { |device, obj, ind, state|
  print "Digital input #{ind} changed to #{(state == 0) ? false : true}\n"
}
CPhidgetInterfaceKit_set_OnInputChange_Handler(ifkit, InputChangeHandler, nil)

OutputChangeHandler = Proc.new { |device, obj, ind, state|
  print "Digital output #{ind} changed to #{(state == 0) ? false : true}\n"
}
CPhidgetInterfaceKit_set_OnOutputChange_Handler(ifkit, OutputChangeHandler, nil)

SensorChangeHandler = Proc.new { |device, obj, ind, val|
  print "Sensor #{ind} changed to #{val}\n"
}
CPhidgetInterfaceKit_set_OnSensorChange_Handler(ifkit, SensorChangeHandler, nil)

CPhidget_open(ifkit, -1)
CPhidget_waitForAttachment(ifkit, 10000)

puts Phidgets::Common.serial_number(ifkit)

print "You have 20 seconds to attach/detach the interface kit. It should activate the callback handlers\n"
sleep 10

CPhidget_close(ifkit)
CPhidget_delete(ifkit)
