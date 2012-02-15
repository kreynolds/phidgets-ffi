module Phidgets
  module FFI
  
    extend ::FFI::Library

  	if Config::CONFIG['target_os'] =~ /darwin/ #Mac OS X
      ffi_lib '/Library/Frameworks/Phidget21.framework/Versions/Current/Phidget21'
    else # Linux
  
      if File.exists?('/usr/lib64/libphidget21.so') 
        ffi_lib '/usr/lib64/libphidget21.so' 
      elsif File.exists?('/usr/lib32/libphidget21.so') 
        ffi_lib '/usr/lib32/libphidget21.so' 
      elsif File.exists?('/usr/lib/libphidget21.so')
        ffi_lib '/usr/lib/libphidget21.so' 
      else
        puts 'Error: Cannot find libphidget21.so. Please install the Phidget Drivers'
      end    
    
    end

  end
end






