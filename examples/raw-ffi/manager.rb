require 'rubygems'
require 'phidgets-ffi'

include Phidgets::FFI
ptr = FFI::MemoryPointer.new(:pointer, 1)
CPhidgetManager.create(ptr)
manager = ptr.get_pointer(0)
CPhidgetManager.open(manager)

sleep(1)
devices_ptr, count = FFI::MemoryPointer.new(:pointer, 70), FFI::MemoryPointer.new(:int)
CPhidgetManager.getAttachedDevices(manager, devices_ptr, count)

devices = devices_ptr.get_array_of_pointer(0, count.get_int(0))

ptr1 = FFI::MemoryPointer.new(:string)
ptr2 = FFI::MemoryPointer.new(:int)

count.get_int(0).times do |i|
  device = devices[0].get_pointer(i*4)

  Common.getDeviceName(device, ptr1)
  name =  ptr1.get_pointer(0).read_string

  Common.getSerialNumber(device, ptr2)
  serial_number = ptr2.get_int(0)
  
  Common.getDeviceVersion(device, ptr2)
  version = ptr2.get_int(0)
  
  print "Device #{i+1}: #{name} v#{version} - Serial Number #{serial_number}\n"
end

CPhidgetManager.freeAttachedDevicesArray(devices_ptr.get_pointer(0))

CPhidgetManager.close(manager)
CPhidgetManager.delete(manager)
