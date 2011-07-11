module Phidgets
  module FFI
    extend ::FFI::Library
    ffi_lib '/Library/Frameworks/Phidget21.framework/Versions/Current/Phidget21'
  end
end