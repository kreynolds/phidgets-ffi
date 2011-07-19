module Phidgets
  module FFI
    # Gets the library version. This contains a version number and a build date.
    #
    # @return [String]
    def self.library_version
      ptr = ::FFI::MemoryPointer.new(:string)
      Phidgets::FFI::Common.getLibraryVersion(ptr)
      strPtr = ptr.get_pointer(0)
      strPtr.null? ? nil : strPtr.read_string
    end

    # Gets the description for an error code.
    #
    # @param [Fixnum] code The error code to get the description of.
    # @return [String]
    def self.error_description(code)
      ptr = ::FFI::MemoryPointer.new(:string)
      Phidgets::FFI::Common.getErrorDescription(code, ptr)
      strPtr = ptr.get_pointer(0)
      strPtr.null? ? nil : strPtr.read_string
    end
  end

  module Utility

    private

    # Given an FFI::MemoryPointer to an object_id, return a reference to it from the ObjectSpace
    #
    # @param [FFI::MemoryPointer] obj_ptr Pointer to an object_id
    # @return [Object] Object referred to by the object_id
    def object_for(obj_ptr)
      (obj_ptr.null? ? nil : ObjectSpace._id2ref(obj_ptr.get_uint(0)))
    end

    # Given an object, return a pointer to it's object_id in the ObjectSpace
    #
    # @param [Object] object for which to create a pointer reference
    # @return [FFI::MemoryPointer] pointer to the object_id
    def pointer_for(obj)
      ::FFI::MemoryPointer.new(:uint).write_uint(obj.object_id)
    end
  end

  module Common
    include Utility

    # Create a pointer for this Device handle .. must be called before open or anything else.
    # Called automatically when objects are instantiated in block form.
    #
    # @return [Boolean] returns true or throws an error
    def create
      ptr = ::FFI::MemoryPointer.new(:pointer, 1)
      self.class::Klass.create(ptr)        
      @handle = ptr.get_pointer(0)
      true
    end

    # Opens a Phidget.
    #
    # @param [Integer] serial_number Serial number of the phidget to open, -1 means any.
    # @return [Boolean] returns true or throws an error
    def open(serial_number=-1)
      Phidgets::FFI::Common.open(@handle, serial_number)
      true
    end
    
    # Opens a Phidget by label.
    #
    # @param [String] str Labels can be up to 10 characters (UTF-8 encoding). Specify nil to open any.
    # @return [Boolean] returns true or throws an error
    def open_label(str=nil)
      Phidgets::FFI::Common.openLabel(@handle, str)
      true
    end
    
    # Closes a Phidget
    #
    # @return [Boolean] returns true or throws an error
    def close
      Phidgets::FFI::Common.close(@handle)
      true
    end

    # Frees a Phidget handle.
    #
    # @return [Boolean] returns true or throws an error
    def delete
      Phidgets::FFI::Common.delete(@handle)
      true
    end
    
    def wait_for_attachment(milliseconds=10000)
      Phidgets::FFI::Common.waitForAttachment(@handle, milliseconds)
      true
    end
    
    # Gets the specific name of a Phidget.
    #
    # @param [FFI::Pointer] pointer An attached phidget handle
    # @return [String] returns the device name
    def self.name(handle)
      ptr = ::FFI::MemoryPointer.new(:string)
      Phidgets::FFI::Common.getDeviceName(handle, ptr)
      strPtr = ptr.get_pointer(0)
      strPtr.null? ? nil : strPtr.read_string
    end
    # Return the name of the instantiated device
    #
    # @return [String] returns the name of this device
    def name; Common.name(@handle); end

    # Gets the serial number of a Phidget.
    #
    # @param [FFI::Pointer] pointer An attached phidget handle
    # @return [Integer] returns the serial number of the phidget
    def self.serial_number(handle)
      ptr = ::FFI::MemoryPointer.new(:int)
      Phidgets::FFI::Common.getSerialNumber(handle, ptr)
      ptr.get_int(0)
    end
    # Return the serial number of the instantiated device
    #
    # @return [Integer] returns the serial number of this device
    def serial_number; Common.serial_number(@handle); end

    # Gets the version of a Phidget.
    #
    # @param [FFI::Pointer] pointer An attached phidget handle
    # @return [Integer] returns the version of a phidget
    def self.version(handle)
      ptr = ::FFI::MemoryPointer.new(:int)
      Phidgets::FFI::Common.getDeviceVersion(handle, ptr)
      ptr.get_int(0)
    end
    # Return the version of the instantiated device
    #
    # @return [Integer] returns the version of this device
    def version; Common.version(@handle); end

    def attached?
      ptr = ::FFI::MemoryPointer.new(:int)
      Phidgets::FFI::Common.getDeviceStatus(@handle, ptr)
      (ptr.get_int(0) == 0) ? false : true
    end
    
    def detached?
      !attached?
    end

    # Gets the type (class) of a Phidget.
    #
    # @param [FFI::Pointer] pointer An attached phidget handle
    # @return [String] returns the type of a phidget
    def self.type(handle)
      ptr = ::FFI::MemoryPointer.new(:string)
      Phidgets::FFI::Common.getDeviceType(handle, ptr)
      strPtr = ptr.get_pointer(0)
      strPtr.null? ? nil : strPtr.read_string
    end
    # Return the type (class) of the instantiated device
    #
    # @return [String] returns the type of this device
    def type; Common.type(@handle); end

    # Gets the label of a Phidget.
    #
    # @param [FFI::Pointer] pointer An attached phidget handle
    # @return [String] returns the label of a phidget
    def self.label(handle)
      ptr = ::FFI::MemoryPointer.new(:string)
      Phidgets::FFI::Common.getDeviceLabel(handle, ptr)
      strPtr = ptr.get_pointer(0)
      strPtr.null? ? nil : strPtr.read_string
    end
    # Return the label of the instantiated device
    #
    # @return [String] returns the label of this device
    def label; Common.label(@handle); end

    # Sets the label of a Phidget. Note that this is nut supported on very old Phidgets, and not yet supported in Windows.
    #
    # @param [String] new_label device label string
    # @return [String] returns the new_label
    def label=(new_label)
      Phidgets::FFI::Common.setDeviceLabel(@handle, new_label)
      new_label
    end
    
    def server_id
      ptr = ::FFI::MemoryPointer.new(:string)
      Phidgets::FFI::Common.getServerID(@handle, ptr)
      strPtr = ptr.get_pointer(0)
      strPtr.null? ? nil : strPtr.read_string
    end
    
    def server_address
      str_ptr, int_ptr = ::FFI::MemoryPointer.new(:string), ::FFI::MemoryPointer.new(:int)
      Phidgets::FFI::Common.getServerID(@handle, str_ptr, int_ptr)
      strPtr = str_ptr.get_pointer(0)
      address = (strPtr.null? ? nil : strPtr.read_string)
      port = int_ptr.get_int(0)
      [address, port]
    end
    
    def server_status
      ptr = ::FFI::MemoryPointer.new(:int)
      Phidgets::FFI::Common.getServerStatus(@handle, ptr)
      ptr.get_int(0)
    end
    
    def self.device_id(handle)
      ptr = ::FFI::MemoryPointer.new(:int)
      Phidgets::FFI::Common.getDeviceID(handle, ptr)
      Phidgets::FFI::DeviceID[ptr.get_int(0)]
    end
    def device_id; Common.device_id(@handle); end
    
    def self.device_class(handle)
      ptr = ::FFI::MemoryPointer.new(:int)
      Phidgets::FFI::Common.getDeviceClass(handle, ptr)
      Phidgets::FFI::DeviceClass[ptr.get_int(0)]
    end
    def device_class; Common.device_class(@handle); end
    
    # Sets an attach handler callback function. This is called when this Phidget is plugged into the system, and is ready for use.
    #
    # @param [String] obj Object to pass to the callback function, optional.
    # @param [Proc] Block When the callback is executed, the device and object are yielded to this block.
    #   As this runs in it's own thread, be sure that all errors are properly handled or the thread will halt and not fire any more. Example:
    #     ifkit.on_attach do |device, obj|
    #       print "Interface Kit Attached #{device.attributes.inspect}\n"
    #     end
    # @return [Boolean] returns true or raises an error
    def on_attach(obj=nil, &block)
      @on_attach_obj = obj
      @on_attach = Proc.new { |handle, obj_ptr|
        yield self, object_for(obj_ptr)
      }
      Phidgets::FFI::Common.set_OnAttach_Handler(@handle, @on_attach, pointer_for(obj))
      true
    end

    def on_detach(obj=nil, &block)
      @on_detach_obj = obj
      @on_detach = Proc.new { |handle, obj_ptr|
        yield self, object_for(obj_ptr)
      }
      Phidgets::FFI::Common.set_OnDetach_Handler(@handle, @on_detach, pointer_for(obj))
    end

    def on_server_connect(obj=nil, &block)
      @on_server_connect_obj = obj
      @on_server_connect = Proc.new { |handle, obj_ptr|
        yield self, object_for(obj_ptr)
      }
      Phidgets::FFI::Common.set_OnServerConnect_Handler(@handle, @on_server_connect, pointer_for(obj))
    end

    def on_server_disconnect(obj=nil, &block)
      @on_server_disconnect_obj = obj
      @on_server_disconnect = Proc.new { |handle, obj_ptr|
        yield self, object_for(obj_ptr)
      }
      Phidgets::FFI::Common.set_OnServerDisconnect_Handler(@handle, @on_server_disconnect, pointer_for(obj))
    end

    def on_error(obj=nil, &block)
      @on_error_obj = obj
      @on_error = Proc.new { |handle, obj_ptr, code, description|
        yield self, object_for(obj_ptr), code, description
      }
      Phidgets::FFI::Common.set_OnError_Handler(@handle, @on_error, pointer_for(obj))
    end

    def on_sleep(obj=nil, &block)
      @on_sleep_obj = obj
      @on_sleep = Proc.new { |obj_ptr|
        yield object_for(obj_ptr)
      }
      Phidgets::FFI::Common.set_OnWillSleep_Handler(@on_sleep, pointer_for(obj))
    end

    def on_wake(obj=nil, &block)
      @on_wake_obj = obj
      @on_wake = Proc.new { |obj_ptr|
        yield object_for(obj_ptr)
      }
      Phidgets::FFI::Common.set_OnWakeup_Handler(@on_wake, pointer_for(obj))
    end
    
    def self.attributes(handle)
      {
        :type => type(handle),
        :name => name(handle),
        :serial_number => serial_number(handle),
        :version => version(handle),
        :label => label(handle),
        :device_class => device_class(handle),
        :device_id => device_id(handle),
      }
    end
    def attributes; Common.attributes(@handle); end
  end
end