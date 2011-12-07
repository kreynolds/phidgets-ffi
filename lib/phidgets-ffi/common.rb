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

  private
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

  # This is the base class from which all Phidget device classes derive.
  module Common
    include Utility

   # Initializes a Phidget. There are two methods that you can use to program Phidgets.
   # 
   # @return [Object]
   #
   # <b>First Method:</b> You can program with a block
   #  Phidgets::InterfaceKit.new do |ifkit| 
   #    ...
   #  end
   #
   # <b>Second Method:</b> You can program without a block
   #
   #  ifkit = Phidgets::InterfaceKit.new
   #
   # The constructor accepts optional arguments. Depending on what is specified as options, a Phidget will be opened in a different manner. The timeout is used for block programming; if no timeout is specified, the default timeout(1000 milliseconds) will be used. Please note that if you are not using the block method and specify a timeout, the timeout will be ignored.  
   #
   # The first available Phidget that meets all the criteria will be opened. If there are two Phidgets of the same type attached to the system, you should specify a serial number or label, as there is no guarantee which Phidget will be selected by the call.
   #
   # @param [Integer] options The first available Phidget that meets all the criteria will be opened.
   # @param [Proc] Block initialize will automatically will open and call wait_for_attachment on the Phidget. Then, the block will yield. Afterwards, close is automatically called.
   #
   # <b>Usage:</b>
   #
   # Open the first available Phidget with an optional timeout(milliseconds).
   #
   # Specify 0 for timeout to wait forever.
   #
   # <b>Parameters:</b> (Integer[optional])
   #  new({:timeout => 5000})
   #
   # <br/>
   #
   # Open a Phidget using a serial number, and an optional timeout(milliseconds).
   #
   # Specify -1 for serial number to open any. Specify 0 for timeout to wait forever.
   #
   # <b>Parameters:</b> (Integer, Integer[optional])
   #  new({:serial_number => -1, :timeout => 5000})
   #
   # <br/>
   #
   # Open a Phidget using a specific label, and an optional timeout(milliseconds).
   #
   # Specify nil for device label to open any. Specify 0 for timeout to wait forever.
   #
   # <b>Parameters:</b> (String, Integer[optional])
   #  new({:label => nil, :timeout => 5000})
   #
   # <br/>
   #
   # Open a Phidget remotely and securely, using a specific serial number, server id, password, and an optional timeout(milliseconds).
   #
   # Specify -1 for serial number to open any. Specify nil for password if it is not required. Specify 0 for timeout to wait forever.
   #
   # <b>Parameters:</b> (Integer, String, String, Integer[optional])
   #  new({:serial_number => -1, :server_id => 'phidgetsbc', :password => nil, :timeout => 5000})
   #
   # <br/>
   #
   # Open a Phidget remotely and securely, using a specific serial number, IP Address, port, password, and an optional timeout(milliseconds).
   #
   # Specify -1 for serial number to open any. Specify nil for password if it is not required. Specify 0 for timeout to wait forever.
   #
   # <b>Parameters:</b> (Integer, String, Integer, String, Integer[optional])
   #  new({:serial_number => -1, :server_address => 'localhost', :port => 5001, :password => nil, :timeout => 5000})
   #
   # <br/>
   #
   # Open a Phidget remotely and securely, using a specific device label, server id, password, and an optional timeout(milliseconds).
   #
   # Specify nil for device label to open any. Specify nil for password if it is not required. Specify 0 for timeout to wait forever.
   #
   # <b>Parameters:</b> (String, String, String, Integer[optional])
   #  new({:label => nil, :server_id => 'phidgetsbc', :password => nil, :timeout => 5000})
   #
   # <br/>
   #
   # Open a Phidget remotely and securely, using a specific label, server address, port, password, and an optional timeout(milliseconds).
   #
   # Specify nil for device label to open any. Specify nil for password if it is not required. Specify 0 for timeout to wait forever.
   #
   # <b>Parameters:</b> (String, String, Integer, String, Integer[optional])
   #  new({:label => nil, :server_address => 'localhost', :port => 5001, :password => nil, :timeout => 5000})
  def initialize(options=nil, &block)
	create
	args_for_open = 0
	with_wait_time = false
	args_to_consider = 0
	
	if !options.nil?
		
		label = (options[:label].nil? ? nil : options[:label].to_s)
		serial_number = (options[:serial_number].nil? ? -1 : options[:serial_number].to_i)
		password = (options[:password].nil? ? nil : options[:password].to_s)
		
		if !options[:server_id].nil?
			if !label.nil?
				open_label_remote(label, options[:server_id].to_s, password)
			else
				open_remote(serial_number, options[:server_id].to_s, password)
			end
		elsif !options[:address].nil?
			if !label.nil?
				open_label_remote_ip(label, options[:address].to_s, options[:port].to_i, password)
			else
				open_remote_ip(serial_number, options[:address].to_s, options[:port].to_i, password)
			end
		else #local
		
			if !label.nil?
				open_label(label)
			else
				open(serial_number)
			end
		end
		
	else    #option is not specified
		open(-1)
	end
	
	
      if block_given?
		if !options.nil? && !options[:timeout].nil? #timeout is given
			wait_for_attachment options[:timeout].to_i
		else
			wait_for_attachment #use default wait time
		end
		yield self
        close
	  end
	end

	private
    # Create a pointer for this Device handle .. must be called before open or anything else.
    # Called automatically when objects are instantiated in block form.
    def create
      ptr = ::FFI::MemoryPointer.new(:pointer, 1)
      self.class::Klass.create(ptr)        
      @handle = ptr.get_pointer(0)
      true
    end

    # Opens a Phidget.
    #
    # @param [Integer] serial_number Serial number of the phidget to open, -1 means any.
    # @return [Boolean] returns true or raises an error
    def open(serial_number=-1)
       Phidgets::FFI::Common.open(@handle, serial_number)
	   true
    end

	# Opens a Phidget.
    #
    # @param [Integer] serial_number Serial number of the phidget to open, -1 means any.
    # @return [Boolean] returns true or raises an error
    def open_remote(serial_number=-1, server_id=nil, password=nil)
	   Phidgets::FFI::Common.openRemote(@handle, serial_number, server_id, password)
	   true
    end
	
	# Opens a Phidget.
    #
    # @param [Integer] serial_number Serial number of the phidget to open, -1 means any.
    # @return [Boolean] returns true or raises an error
    def open_remote_ip(serial_number=-1, server_address=nil, port=5001, password=nil)
    	Phidgets::FFI::Common.openRemoteIP(@handle, serial_number, server_address, port, password)
	    true
    end	

	# Opens a Phidget.
    #
    # @param [Integer] serial_number Serial number of the phidget to open, -1 means any.
    # @return [Boolean] returns true or raises an error
    def open_label_remote(label=nil, server_id=nil, password=nil)
		Phidgets::FFI::Common.openLabelRemote(@handle, label, server_id, password)
	    true
    end

	# Opens a Phidget.
    #
    # @param [Integer] serial_number Serial number of the phidget to open, -1 means any.
    # @return [Boolean] returns true or raises an error
    def open_label_remote_ip(label=nil, server_address=nil, port=5001, password=nil)
		Phidgets::FFI::Common.openLabelRemoteIP(@handle, label, server_address, port, password)
		  
			true
    end

	# Opens a Phidget.
    #
    # @param [Integer] serial_number Serial number of the phidget to open, -1 means any.
    # @return [Boolean] returns true or raises an error
    def open_label(label=nil)

		Phidgets::FFI::Common.openLabel(@handle, label)
	    true
    end
	
	public

    # Closes and frees a Phidget. This should be called before closing your application or things may not shut down cleanly.
    #
    # @return [Boolean] returns true or raises an error
    def close
	  remove_common_event_handlers
	  remove_specific_event_handlers
	  sleep 0.2
      Phidgets::FFI::Common.close(@handle) 
	  delete
      true
    end

	
	private
    # Frees a Phidget handle.
    #
    # @return [Boolean] returns true or raises an error
    def delete
      Phidgets::FFI::Common.delete(@handle)
      true
    end
    
	public
	# This method can be called after the Phidget object has been created. This method blocks indefinitely until the Phidget becomes available. This can be quite some time (forever), if the Phidget is never plugged in. Please note that this call is not needed if you are programming inside a block. If you are programming inside a block, you can specify the wait time in the {Phidgets::Common#initialize} constructor
	#
	# @param [Integer] wait_time Time to wait for the attachment. Specify 0 to wait forever. This is Optional. The default wait time is 1000 milliseconds.
	# @return [Boolean] returns true or raises an error
    def wait_for_attachment(wait_time=1000)
	
      Phidgets::FFI::Common.waitForAttachment(@handle, wait_time)
	  if attached?
		load_device_attributes
	  end
	  
      true

    end
    
	# Return the attached status of this Phidget, depending on whether the Phidget is physically plugged into the computer, initialized and is ready to use. 
    #
    # @return [Boolean] returns the attached status
	def attached?
		Common.device_status(@handle);
    end
	
	# Return the detached status of this Phidget
    #
    # @return [Boolean] returns the detached status
    def detached?
      !attached?
    end
	
	# Returns the name of the Phidget
	#
	# @return [String] returns the name of the Phidget, or raises an error
    def name; Common.name(@handle); end
	
	# Returns the serial number of the Phidget
	#
	# @return [Integer] returns the serial number of the Phidget, or raises an error
    def serial_number; Common.serial_number(@handle); end
	
	# Returns the device version of the Phidget
	#
	# @return [Integer] returns the device version of the Phidget, or raises an error
    def version; Common.version(@handle); end
	
	# Returns the device type of the Phidget
	#
	# @return [String] returns the device type of the Phidget, or raises an error
    def type; Common.type(@handle); end
	
	# Returns the device id of the Phidget
	#
	# @return [String] returns the device id of the Phidget, or raises an error
	def id; Common.device_id(@handle); end
	#def device_id; Common.device_id(@handle); end #delete

	# Returns the device class of the Phidget
	#
	# @return [String] returns the device class of the Phidget, or raises an error
    def device_class; Common.device_class(@handle); end
		
	# Returns the label of the Phidget
	#
	# @return [String] returns the label of the Phidget, or raises an error
    def label; Common.label(@handle); end

	# @return [String] returns the server id for a Phidget opened over the network, or raises an error
    def server_id; Common.server_id(@handle); end

	# @return [String, Integer] returns the Phidget WebService server address and port for a Phidget opened over the network, or raises an error
	def server_address; Common.server_address(@handle); end

	# @return [Boolean] returns the server status of this Phidget or raises an error
	def attached_to_server?
	  Common.server_status(@handle)
    end
    
	# @return [Boolean] returns the detached to server status of this Phidget or raises an error
	def detached_to_server?
      !attached_to_server?
    end
	
    # Sets an attach handler callback function. This is called when the Phidget is plugged into the system, and is ready for use.
    #
    # @param [String] obj Object to pass to the callback function. This is optional.
    # @param [Proc] Block When the callback is executed, the device and object are yielded to this block.
    # @example
    #     ifkit.on_attach do |device, obj|
    #       puts "InterfaceKit attached #{device.attributes.inspect}"
    #     end
    # As this runs in it's own thread, be sure that all errors are properly handled or the thread will halt and not fire any more.
    # @return [Boolean] returns true or raises an error
    def on_attach(obj=nil, &block)
	  @on_attach_obj = obj
      @on_attach = Proc.new { |handle, obj_ptr|
		load_device_attributes
        yield self, object_for(obj_ptr)
    	 }
      Phidgets::FFI::Common.set_OnAttach_Handler(@handle, @on_attach, pointer_for(obj))
	  true
    end

    # Sets a detach handler callback function. This is called when the Phidget is physically detached from the system, and is no longer available.
    #
    # @param [String] obj Object to pass to the callback function. This is optional.
    # @param [Proc] Block When the callback is executed, the device and object are yielded to this block.
    # @example
    #     ifkit.on_detach do |device, obj|
    #       puts "InterfaceKit detached #{device.attributes.inspect}"
    #     end
    # As this runs in it's own thread, be sure that all errors are properly handled or the thread will halt and not fire any more.
    # @return [Boolean] returns true or raises an error
    def on_detach(obj=nil, &block)
      @on_detach_obj = obj
      @on_detach = Proc.new { |handle, obj_ptr|
        yield self, object_for(obj_ptr)
      }
      Phidgets::FFI::Common.set_OnDetach_Handler(@handle, @on_detach, pointer_for(obj))
	  true
    end

    # Sets an error handler callback function. This is called when an asynchronous error occurs. This is generally used for network errors, and device hardware error messages.
    #
    # @param [String] obj Object to pass to the callback function. This is optional.
    # @param [Proc] Block When the callback is executed, the device and object are yielded to this block.
    # @example
    #     ifkit.on_error do |device, obj, code, description|
    #       puts "Error - code #{code}, description #{description}"
    #     end
    # As this runs in it's own thread, be sure that all errors are properly handled or the thread will halt and not fire any more.
    # @return [Boolean] returns true or raises an error
    def on_error(obj=nil, &block)
      @on_error_obj = obj
      @on_error = Proc.new { |handle, obj_ptr, code, description|
        yield self, object_for(obj_ptr), code, description
      }
      Phidgets::FFI::Common.set_OnError_Handler(@handle, @on_error, pointer_for(obj))
	  true
    end
	
    # Sets a server connect handler callback function. This is called for network opened Phidgets when a connection to the PhidgetWebService has been established.
    #
    # @param [String] obj Object to pass to the callback function. This is optional.
    # @param [Proc] Block When the callback is executed, the device and object are yielded to this block.
    # @example
    #     ifkit.on_server_connect do |device, obj|
    #       puts "Server connect #{device.attributes.inspect}"
    #     end
    # As this runs in it's own thread, be sure that all errors are properly handled or the thread will halt and not fire any more.
    # @return [Boolean] returns true or raises an error
    def on_server_connect(obj=nil, &block)
      @on_server_connect_obj = obj
      @on_server_connect = Proc.new { |handle, obj_ptr|
        yield self, object_for(obj_ptr)
      }
      Phidgets::FFI::Common.set_OnServerConnect_Handler(@handle, @on_server_connect, pointer_for(obj))
	  true
    end

    # Sets a server disconnect handler callback function. This is called for network opened Phidgets when a connectiotn to the PhidgetWebService has been broken - either by calling close, or by network trouble, etc....
    #
    # @param [String] obj Object to pass to the callback function. This is optional.
    # @param [Proc] Block When the callback is executed, the device and object are yielded to this block.
    # @example
    #     ifkit.on_server_disonnect do |device, obj|
    #       puts "Server disonnect #{device.attributes.inspect}"
    #     end
    # As this runs in it's own thread, be sure that all errors are properly handled or the thread will halt and not fire any more.
    # @return [Boolean] returns true or raises an error
    def on_server_disconnect(obj=nil, &block)
      @on_server_disconnect_obj = obj
      @on_server_disconnect = Proc.new { |handle, obj_ptr|
        yield self, object_for(obj_ptr)
      }
      Phidgets::FFI::Common.set_OnServerDisconnect_Handler(@handle, @on_server_disconnect, pointer_for(obj))
	  true
    end

    # Sets a sleep handler callback function. This is called when the MacOS X is entering sleep mode.
    #
    # @param [String] obj Object to pass to the callback function. This is optional.
    # @param [Proc] Block When the callback is executed, the device and object are yielded to this block.
    # @example
    #     ifkit.on_sleep do |obj|
    #       puts "System sleeping"
    #     end
    # As this runs in it's own thread, be sure that all errors are properly handled or the thread will halt and not fire any more.
    # @return [Boolean] returns true or raises an error
    # @note Used only in Mac OS X		
	def on_sleep(obj=nil, &block)
      @on_sleep_obj = obj
      @on_sleep = Proc.new { |obj_ptr|
        yield object_for(obj_ptr)
      }
      Phidgets::FFI::Common.set_OnWillSleep_Handler(@on_sleep, pointer_for(obj))
	  true
	  
    end
	
    # Sets a wake callback function. This is called when the MacOS X is waking up from sleep mode.
    #
    # @param [String] obj Object to pass to the callback function. This is optional.
    # @param [Proc] Block When the callback is executed, the device and object are yielded to this block.
    # @example
    #     ifkit.on_wake do |obj|
    #       puts "System waking up"
    #     end
    # As this runs in it's own thread, be sure that all errors are properly handled or the thread will halt and not fire any more.
    # @return [Boolean] returns true or raises an error
    # @note Used only in Mac OS X		
    def on_wake(obj=nil, &block)
      @on_wake_obj = obj
      @on_wake = Proc.new { |obj_ptr|
        yield object_for(obj_ptr)
      }
      Phidgets::FFI::Common.set_OnWakeup_Handler(@on_wake, pointer_for(obj))
      true
	end

    attr_reader :attributes

	private
	
	def self.device_status(handle)
		ptr = ::FFI::MemoryPointer.new(:int)
		Phidgets::FFI::Common.getDeviceStatus(handle, ptr)
		(ptr.get_int(0) == 0) ? false : true
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

    # Gets the serial number of a Phidget.
    #
    # @param [FFI::Pointer] pointer An attached phidget handle
    # @return [Integer] returns the serial number of the phidget
    def self.serial_number(handle)
	  ptr = ::FFI::MemoryPointer.new(:int)
	  Phidgets::FFI::Common.getSerialNumber(handle, ptr)
      ptr.get_int(0)
    end

    # Gets the version of a Phidget.
    #
    # @param [FFI::Pointer] pointer An attached phidget handle
    # @return [Integer] returns the version of a phidget
    def self.version(handle)
      ptr = ::FFI::MemoryPointer.new(:int)
      Phidgets::FFI::Common.getDeviceVersion(handle, ptr)
      ptr.get_int(0)
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

public
    # Sets the label of a Phidget. Note that this is not supported on very old Phidgets, and not yet supported in Windows. The label can be up to ten characters, and is stored in the Flash memory of newer Phidgets. This label can be set programatically, and is non-volatile - so it is remembered even if the Phidget is unplugged.
    #
    # @param [String] new_label New label
    # @return [String] returns the label, or raises an error
    def label=(new_label)
	  Phidgets::FFI::Common.setDevicelabel(@handle, new_label)
	  new_label
    end

    def self.device_id(handle)
      ptr = ::FFI::MemoryPointer.new(:int)
      Phidgets::FFI::Common.getDeviceID(handle, ptr)
      Phidgets::FFI::DeviceID[ptr.get_int(0)]
    end

    def self.device_class(handle)
      ptr = ::FFI::MemoryPointer.new(:int)
      Phidgets::FFI::Common.getDeviceClass(handle, ptr)
      Phidgets::FFI::DeviceClass[ptr.get_int(0)]
    end

	def self.server_id(handle)
      ptr = ::FFI::MemoryPointer.new(:string)
      Phidgets::FFI::Common.getServerID(handle, ptr)
      strPtr = ptr.get_pointer(0)
      strPtr.null? ? nil : strPtr.read_string
    end
	
    def self.server_address(handle)
	  str_ptr, int_ptr = ::FFI::MemoryPointer.new(:string), ::FFI::MemoryPointer.new(:int)
	  Phidgets::FFI::Common.getServerAddress(handle, str_ptr, int_ptr)
      strPtr = str_ptr.get_pointer(0)
      address = (strPtr.null? ? nil : strPtr.read_string)
      port = int_ptr.get_int(0)
      [address, port]
    end

    def self.server_status(handle)
      ptr = ::FFI::MemoryPointer.new(:int)
      Phidgets::FFI::Common.getServerStatus(handle, ptr)
	  #(ptr.get_int(0) == 0) ? false : true
	  Phidgets::FFI::ServerStatus[ptr.get_int(0)]
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

	public

	#The attributes of a Phidget
    def attributes; Common.attributes(@handle); end
    
	private
	def remove_common_event_handlers
	  Phidgets::FFI::Common.set_OnDetach_Handler(@handle, nil, nil)
	  Phidgets::FFI::Common.set_OnAttach_Handler(@handle, nil, nil)
	  Phidgets::FFI::Common.set_OnServerConnect_Handler(@handle, nil, nil)
	  Phidgets::FFI::Common.set_OnServerDisconnect_Handler(@handle, nil, nil)
	  Phidgets::FFI::Common.set_OnError_Handler(@handle, nil, nil) 
	end
  end
end
