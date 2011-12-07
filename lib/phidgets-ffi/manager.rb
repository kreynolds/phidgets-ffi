module Phidgets
 
 # This class represents a PhidgetManager.
 class Manager
    Klass = Phidgets::FFI::CPhidgetManager
    include Utility

   # Initializes a PhidgetManager. There are two methods that you can use to program the PhidgetManager.
   # 
   # @param [String] options Information required to connect to the WebService. This is optional. If no option is specified, it is assumed that the address is localhost and port is 5001
   # @param [Proc] Block When the callback is executed, the device and object are yielded to this block.
   #	
   # @return [Object]
   #
   # <b>First Method:</b> You can program with a block. 
   #  options = {:address => 'localhost', :port => 5001, :server_id => nil, :password => nil}
   #  Phidgets::Manager.new(options) do |man| 
   #    ...
   #  end
   #
   # <b>Second Method:</b> You can program without a block
   #  man = Phidgets::Manager.new
	def initialize(options={}, &block)
	  create
      
	  password = (options[:password].nil? ? nil : options[:password].to_s)
	  if !options[:server_id].nil? or !options[:address].nil?
		if !options[:server_id].nil?
			open_remote(options, password)
		else
			open_remote_ip(options, password)
		end
		sleep 3
	  else
		open
	  end
      if block_given?
        yield self
        close
      end
    end
    
    private
	def create
      ptr = ::FFI::MemoryPointer.new(:pointer, 1)
      Klass.create(ptr)        
      @handle = ptr.get_pointer(0)
      true
    end

    def open 
      Klass.open(@handle)
      
      sleep 1
      true
    end
    
	def open_remote(options, password)
      Klass.openRemote(@handle, options[:server_id].to_s, password)
      sleep 2
      true
    end
	
	def open_remote_ip(options, password)
      Klass.openRemoteIP(@handle, options[:address].to_s, options[:port].to_i, password)
      sleep 2
      true
    end
	
    public
	
    # Closes and frees a PhidgetManager
    # 
    # @return [Boolean] returns true or raises an error
	def close
      remove_specific_event_handlers
	  sleep 0.2
	  Klass.close(@handle)
      Klass.delete(@handle)
	  true
    end

	# @return [Array] returns a list of the handles of all currently attached Phidgets, or raises an error. You can use the handles with the Phidgets::Common class methods; See the example for more details.
    def devices
		devices_ptr, count = ::FFI::MemoryPointer.new(:pointer, 300), ::FFI::MemoryPointer.new(:int)
        Klass.getAttachedDevices(@handle, devices_ptr, count)
        
        devices = devices_ptr.get_array_of_pointer(0, count.get_int(0))

        device_array = []
        count.get_int(0).times do |i|
			device_array[i] = devices[0].get_pointer(i*Phidgets::FFI::FFI_POINTER_SIZE)
			
        end
        
        #Klass.freeAttachedDevicesArray(devices_ptr) #error
      
      device_array
	  
    end

	# @return [String] returns the server id of a remotely opened PhidgetManager, or raises an error. This will fail if the manager was opened locally.
    def server_id
      ptr = ::FFI::MemoryPointer.new(:string)
      Phidgets::FFI::Common.getServerID(@handle, ptr)
      strPtr = ptr.get_pointer(0)
      strPtr.null? ? nil : strPtr.read_string
    end
    
	# @return [String] returns the address and port of a remotely opened PhidgetManager, or raises an error. This will fail if the manager was opened locally.
    def server_address
      str_ptr, int_ptr = ::FFI::MemoryPointer.new(:string), ::FFI::MemoryPointer.new(:int)
      Phidgets::FFI::Common.getServerID(@handle, str_ptr, int_ptr)
      strPtr = str_ptr.get_pointer(0)
      address = (strPtr.null? ? nil : strPtr.read_string)
      port = int_ptr.get_int(0)
      [address, port]
    end
	
	# @return [String] returns the connected to server status, or raises an error    
    def status
      ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getServerStatus(@handle, ptr)
      Phidgets::FFI::ServerStatus[ptr.get_int(0)]
    end

    # Sets an attach handler callback function. This is called when a Phidget is plugged into the system.
    #
    # @param [String] obj Object to pass to the callback function. This is optional.
    # @param [Proc] Block When the callback is executed, the device and object are yielded to this block.
    # @example
    #     manager.on_attach do |device_ptr, obj|
    #       puts "Attaching #{Phidgets::Common.name(device_ptr)}"
    #     end
    # As this runs in it's own thread, be sure that all errors are properly handled or the thread will halt and not fire any more.
    # @return [Boolean] returns true or raises an error
    def on_attach(obj=nil, &block)
      @on_attach_obj = obj
      @on_attach = Proc.new { |handle, obj_ptr|
	    yield handle, object_for(obj_ptr)
      }
      Klass.set_OnAttach_Handler(@handle, @on_attach, pointer_for(obj))
    end

    # Sets a detach handler callback function. This is called when a Phidget is unplugged from the system.
    #
    # @param [String] obj Object to pass to the callback function. This is optional.
    # @param [Proc] Block When the callback is executed, the device and object are yielded to this block.
    # @example
    #     manager.on_detach do |device_ptr, obj|
    #       puts "Detaching #{Phidgets::Common.name(device_ptr)}"
    #     end
    # As this runs in it's own thread, be sure that all errors are properly handled or the thread will halt and not fire any more.
    # @return [Boolean] returns true or raises an error
    def on_detach(obj=nil, &block)
      @on_detach_obj = obj
      @on_detach = Proc.new { |handle, obj_ptr|
        yield handle, object_for(obj_ptr)
      }
      Klass.set_OnDetach_Handler(@handle, @on_detach, pointer_for(obj))
    end

    # Sets a server connect handler callback function. This is used for opening the PhidgetManager remotely, and is called when a connection to the server has been made.
    #
    # @param [String] obj Object to pass to the callback function. This is optional.
    # @param [Proc] Block When the callback is executed, the device and object are yielded to this block.
    # @example
    #     manager.on_server_connect do |obj|
    #        puts 'Connected'
    #     end
    # As this runs in it's own thread, be sure that all errors are properly handled or the thread will halt and not fire any more.
    # @return [Boolean] returns true or raises an error
    def on_server_connect(obj=nil, &block)
      @on_server_connect_obj = obj
      @on_server_connect = Proc.new { |handle, obj_ptr|
        yield self, object_for(obj_pointer)
      }
      Klass.set_OnServerConnect_Handler(@handle, @on_server_connect, pointer_for(obj))
    end

    # Sets a server disconnect handler callback function. This is used for opening the PhidgetManager remotely, and is called when a connection to the server has been lost
    #
    # @param [String] obj Object to pass to the callback function. This is optional.
    # @param [Proc] Block When the callback is executed, the device and object are yielded to this block.
    # @example
    #     manager.on_server_disconnect do |obj|
    #       puts 'Disconnected'
    #     end
    # As this runs in it's own thread, be sure that all errors are properly handled or the thread will halt and not fire any more.
    # @return [Boolean] returns true or raises an error
    def on_server_disconnect(obj=nil, &block)
      @on_server_disconnect_obj = obj
      @on_server_disconnect = Proc.new { |handle, obj_ptr|
        yield self, object_for(obj_ptr)
      }
      Klass.set_OnServerDisconnect_Handler(@handle, @on_server_disconnect, pointer_for(obj))
    end

    # Sets a error handler callback function. This is called when an asynchronous error occurs.
    #
    # @param [String] obj Object to pass to the callback function. This is optional.
    # @param [Proc] Block When the callback is executed, the device and object are yielded to this block.
    # @example
    #     manager.on_error do |obj|
    #       puts "Error (#{code}): #{reason}"
    #     end
    # As this runs in it's own thread, be sure that all errors are properly handled or the thread will halt and not fire any more.
    # @return [Boolean] returns true or raises an error
    def on_error(obj=nil, &block)
      @on_error_obj = obj
      @on_error = Proc.new { |handle, obj_ptr, code, description|
        yield self, object_for(obj_ptr), code, description
      }
      Klass.set_OnError_Handler(@handle, @on_error, pointer_for(obj))
    end
	
	private
	
	def remove_specific_event_handlers
		Klass.set_OnAttach_Handler(@handle, nil, nil)
		Klass.set_OnDetach_Handler(@handle, nil, nil)
		Klass.set_OnServerConnect_Handler(@handle, nil, nil)
		Klass.set_OnServerDisconnect_Handler(@handle, nil, nil)
	end
  end
end