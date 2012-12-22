require 'rubygems'
require 'phidgets-ffi'

ptr = FFI::MemoryPointer.new(:string, 1)
if !(res = Phidgets::FFI::CPhidget_getLibraryVersion(ptr))
  $stderr.puts "Unable to get library version"
  exit!(res)
else
  puts ptr.get_pointer(0).read_string
end
