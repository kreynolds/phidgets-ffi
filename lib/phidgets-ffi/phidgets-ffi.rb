module Phidgets
  module FFI
  
    extend ::FFI::Library

    ffi_lib ['/Library/Frameworks/Phidget21.framework/Versions/Current/Phidget21', '/usr/lib/libphidget21.so', '/usr/lib64/libphidget21.so', '/usr/lib32/libphidget21.so', 'Phidget21', 'libphidget21.so']

  end
end