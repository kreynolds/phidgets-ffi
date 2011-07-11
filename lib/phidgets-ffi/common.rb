module Phidgets
  module FFI
    def self.library_version
      ptr = ::FFI::MemoryPointer.new(:string)
      Phidgets::FFI::Common.getLibraryVersion(ptr)
      strPtr = ptr.get_pointer(0)
      strPtr.null? ? nil : strPtr.read_string
    end

    def self.error_description(code)
      ptr = ::FFI::MemoryPointer.new(:string)
      Phidgets::FFI::Common.getErrorDescription(code, ptr)
      strPtr = ptr.get_pointer(0)
      strPtr.null? ? nil : strPtr.read_string
    end
  end

  module Common
    def create
      ptr = ::FFI::MemoryPointer.new(:pointer, 1)
      self.class::Klass.create(ptr)        
      @handle = ptr.get_pointer(0)
      true
    end

    def open(serial_number=-1)
      Phidgets::FFI::Common.open(@handle, serial_number)
      true
    end
    
    def open_label(str)
      Phidgets::FFI::Common.openLabel(@handle, str)
      true
    end
    
    def close
      Phidgets::FFI::Common.close(@handle)
      true
    end

    def delete
      Phidgets::FFI::Common.delete(@handle)
      true
    end
    
    def wait_for_attachment(milliseconds=10000)
      Phidgets::FFI::Common.waitForAttachment(@handle, milliseconds)
      true
    end
    
    def self.name(handle)
      ptr = ::FFI::MemoryPointer.new(:string)
      Phidgets::FFI::Common.getDeviceName(handle, ptr)
      strPtr = ptr.get_pointer(0)
      strPtr.null? ? nil : strPtr.read_string
    end
    def name; Common.name(@handle); end

    def self.serial_number(handle)
      ptr = ::FFI::MemoryPointer.new(:int)
      Phidgets::FFI::Common.getSerialNumber(handle, ptr)
      ptr.get_int(0)
    end
    def serial_number; Common.serial_number(@handle); end

    def self.version(handle)
      ptr = ::FFI::MemoryPointer.new(:int)
      Phidgets::FFI::Common.getDeviceVersion(handle, ptr)
      ptr.get_int(0)
    end
    def version; Common.version(@handle); end

    def attached?
      ptr = ::FFI::MemoryPointer.new(:int)
      Phidgets::FFI::Common.getDeviceStatus(@handle, ptr)
      (ptr.get_int(0) == 0) ? false : true
    end
    
    def detached?
      !attached?
    end

    def self.type(handle)
      ptr = ::FFI::MemoryPointer.new(:string)
      Phidgets::FFI::Common.getDeviceType(handle, ptr)
      strPtr = ptr.get_pointer(0)
      strPtr.null? ? nil : strPtr.read_string
    end
    def type; Common.type(@handle); end

    def self.label(handle)
      ptr = ::FFI::MemoryPointer.new(:string)
      Phidgets::FFI::Common.getDeviceLabel(handle, ptr)
      strPtr = ptr.get_pointer(0)
      strPtr.null? ? nil : strPtr.read_string
    end
    def label; Common.label(@handle); end

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
    
    def on_attach(data=nil, &block)
      @on_attach = Proc.new { |handle, data_ptr|
        yield self, data_ptr
      }
      Phidgets::FFI::Common.set_OnAttach_Handler(@handle, @on_attach, data)
    end

    def on_detach(data=nil, &block)
      @on_detach = Proc.new { |handle, data_ptr|
        yield self, data_ptr
      }
      Phidgets::FFI::Common.set_OnDetach_Handler(@handle, @on_detach, data)
    end

    def on_server_connect(data=nil, &block)
      @on_server_connect = Proc.new { |handle, data_ptr|
        yield self, data_ptr
      }
      Phidgets::FFI::Common.set_OnServerConnect_Handler(@handle, @on_server_connect, data)
    end

    def on_server_disconnect(data=nil, &block)
      @on_server_disconnect = Proc.new { |handle, data_ptr|
        yield self, data_ptr
      }
      Phidgets::FFI::Common.set_OnServerDisconnect_Handler(@handle, @on_server_disconnect, data)
    end

    def on_error(data=nil, &block)
      @on_error = Proc.new { |handle, data_ptr, code, description|
        yield self, data_ptr, code, description
      }
      Phidgets::FFI::Common.set_OnError_Handler(@handle, @on_error, data)
    end

    def on_sleep(data=nil, &block)
      @on_sleep = Proc.new { |data_ptr|
        yield data_ptr
      }
      Phidgets::FFI::Common.set_OnWillSleep_Handler(@on_sleep, data)
    end

    def on_wake(data=nil, &block)
      @on_wake = Proc.new { |data_ptr|
        yield data_ptr
      }
      Phidgets::FFI::Common.set_OnWakeup_Handler(@on_wake, data)
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