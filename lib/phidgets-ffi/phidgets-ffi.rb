module Phidgets
  module FFI
  
    require 'sys/uname'
    os_name = Sys::Uname.sysname
    parsed_os_name = os_name.downcase
	
    extend ::FFI::Library

	if parsed_os_name.include? "darwin" #Mac OS X
      ffi_lib '/Library/Frameworks/Phidget21.framework/Versions/Current/Phidget21'
    else # Linux
      ffi_lib '/usr/lib/libphidget21.so' 
    end

  end
end






