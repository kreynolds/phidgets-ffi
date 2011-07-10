require 'rubygems'
require 'phidgets-ffi'

include PhidgetsFFI

ptr = FFI::MemoryPointer.new(:pointer, 1)
CPhidgetManager_create(ptr)
manager = ptr.get_pointer(0)
CPhidgetManager_open(manager)

sleep(1)
devices_ptr, count = FFI::MemoryPointer.new(:pointer, 1), FFI::MemoryPointer.new(:int)
CPhidgetManager_getAttachedDevices(manager, devices_ptr, count)
devices = devices_ptr.get_array_of_pointer(0, count.get_int(0))

ptr1 = FFI::MemoryPointer.new(:string)
ptr2 = FFI::MemoryPointer.new(:int)
devices.each_with_index do |device, i|
  device = device.get_pointer(0)

  CPhidget_getDeviceName(device, ptr1)
  name =  ptr1.get_pointer(0).read_string

  CPhidget_getSerialNumber(device, ptr2)
  serial_number = ptr2.get_int(0)
  
  CPhidget_getDeviceVersion(device, ptr2)
  version = ptr2.get_int(0)
  
  print "Device #{i+1}: #{name} v#{version} - Serial Number #{serial_number}\n"
end

CPhidgetManager_freeAttachedDevicesArray(devices_ptr.get_pointer(0))
CPhidgetManager_close(manager)
CPhidgetManager_delete(manager)
