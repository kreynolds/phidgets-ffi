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

include PhidgetsFFI

ifkit = FFI::MemoryPointer.new(:pointer, 1)
if !(res = CPhidgetInterfaceKit_create(ifkit))
  $stderr.puts "Unable to create interface kit"
  exit!(res)
else
  ifkit = ifkit.get_pointer(0)
end

# Create an attachment and detachment handler
AttachHandler = Proc.new { |device, ptr|
  print "Device attached: #{device_name_for(device)} (#{serial_number_for(device)})\n"
}
CPhidget_set_OnAttach_Handler(ifkit, AttachHandler, nil)
DetachHandler = Proc.new { |device, ptr|
  print "Device detached: #{device_name_for(device)} (#{serial_number_for(device)})\n"
}
CPhidget_set_OnDetach_Handler(ifkit, DetachHandler, nil)

CPhidget_open(ifkit, -1)
CPhidget_waitForAttachment(ifkit, 10000)

print "You have 20 seconds to attach/detach the interface kit. It should activate the callback handlers\n"
sleep 20

CPhidget_close(ifkit)
CPhidget_delete(ifkit)