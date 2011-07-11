require 'rubygems'
require 'phidgets-ffi'

include Phidgets::FFI

f = FFI::MemoryPointer.new(:pointer, 1)
if !(res = Phidgets::FFI::CPhidgetServo.create(f))
  $stderr.puts "Unable to create servo"
  exit!(res)
else
  servo = f.get_pointer(0)
end
f = nil
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

# Create an attachment and detachment handler
AttachHandler = Proc.new { |device, ptr|
  print "Device attached: #{device_name_for(device)} (#{serial_number_for(device)})\n"
  tmp = FFI::MemoryPointer.new(:double)
  CPhidgetServo_getPositionMax(device, 0, tmp)
  print "Max: #{tmp.get_double(0)}\n"
  CPhidgetServo_getPositionMin(device, 0, tmp)
  print "Min: #{tmp.get_double(0)}\n"
}
CPhidget_set_OnAttach_Handler(servo, AttachHandler, nil)
DetachHandler = Proc.new { |device, ptr|
  print "Device detached: #{device_name_for(device)} (#{serial_number_for(device)})\n"
}
CPhidget_set_OnDetach_Handler(servo, DetachHandler, nil)

PositionChangeHandler = Proc.new { |device, ptr, index, position|
  print "Moving motor #{index} to #{position}\n"
}
CPhidgetServo_set_OnPositionChange_Handler(servo, PositionChangeHandler, nil)

CPhidget_open(servo, -1)
CPhidget_waitForAttachment(servo, 10000)

ptr = FFI::MemoryPointer.new(:int)
exit! if CPhidgetServo_getEngaged(servo, 0, ptr) != 0
#CPhidgetServo_setEngaged(servo, 0, 1)

CPhidgetServo_getServoType(servo, 0, ptr)
print "Servo Type: #{ServoType[ptr.get_int(0)]}\n"

tmp = FFI::MemoryPointer.new(:double)
CPhidgetServo_getPositionMax(servo, 0, tmp)
max = tmp.get_double(0)
10.times do
  CPhidgetServo_setPosition(servo, 0, rand(max))
  sleep 1
end

CPhidgetServo_setEngaged(servo, 0, 0)
CPhidget_close(servo)
CPhidget_delete(servo)