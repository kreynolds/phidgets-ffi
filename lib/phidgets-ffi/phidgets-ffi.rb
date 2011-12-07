module Phidgets
  module FFI
  
    extend ::FFI::Library

  	if Config::CONFIG['target_os'] =~ /darwin/ #Mac OS X
      ffi_lib '/Library/Frameworks/Phidget21.framework/Versions/Current/Phidget21'
    else # Linux
      ffi_lib '/usr/lib/libphidget21.so' 
    end

  end
end






