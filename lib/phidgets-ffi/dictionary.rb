module Phidgets
  
    # This class represents a PhidgetDictionary.
	class Dictionary

    Klass = Phidgets::FFI::CPhidgetDictionary
    include Utility
    
#    attr_accessor :key_sleep, :handler_sleep

   # Initializes a PhidgetDictionary. There are two methods that you can use to program the PhidgetDictionary.
   # 
   # @param [String] options Information required to connect to the WebService. This is optional. If no option is specified, it is assumed that the address is localhost and port is 5001
   # @param [Proc] Block When the callback is executed, the device and object are yielded to this block.
   #	
   # @return [Object]
   #
   # <b>First Method:</b> You can program with a block. Please note that {Phidgets::Dictionary#open} will have to be called afterwards to open the PhidgetDictionary over the WebService.
   #  options = {:address => 'localhost', :port => 5001, :server_id => nil, :password => nil}
   #  Phidgets::Dictionary.new(options) do |dict| 
   #    ...
   #  end
   #
   # <b>Second Method:</b> You can program without a block
   #
   #  dict = Phidgets::Dictionary.new
   def initialize(options={}, &block)
      @key_sleep, @handler_sleep = 0.1, 0.5
      @listeners = {}
      @options = {:address => 'localhost', :port => 5001, :server_id => nil, :password => nil}.merge(options)

      create
      if block_given?
        open(@options)
        yield self
        close
      end
    end

    private
	
	# Creates a PhidgetDictionary.
    # 
    # @return [Boolean] returns true or raises an error
    def create
      ptr = ::FFI::MemoryPointer.new(:pointer, 1)
      Klass.create(ptr)        
      @handle = ptr.get_pointer(0)
      true
    end

	public
    
	# Opens a PhidgetDictionary over the WebService. 
	# If you are not programming with the block method, you will have to call this explicitly.
	# This is called automatically if you are programming with the block method. 
	#
	# <b>Usage:</b>
	#
	# Open a PhidgetDictionary using an address, port, and an optional password.
	#  options = {:address => 'localhost', :port => 5001, :password => nil}
	#  dict.open(options)
	#
	# Open a PhidgetDictionary using a server id, and an optional password.
	#  options = {:server_id => 'localhost', :password => nil}
	#  dict.open(options)
	# @return [Boolean] returns true or raises an error
	def open(options)
      password = (options[:password].nil? ? nil : options[:password].to_s)
      if !options[:server_id].nil?
        Klass.openRemote(@handle, options[:server_id].to_s, password)
      else
        Klass.openRemoteIP(@handle, options[:address].to_s, options[:port].to_i, password)
      end
      sleep 1
      true
    end
    
    # Closes and frees a PhidgetDictionary
    # 
    # @return [Boolean] returns true or raises an error
    def close
      Klass.close(@handle)
	  sleep 0.2
      Klass.delete(@handle)
      true
    end
    
	# Adds a key/value pair to the dictionary. Or, changes an existing key's value.
	# @param [String] key key
	# @param [String, Boolean] Value <b>:value</b> => value, <b>:persistent</b> => whether the key stays in the dictionary after the client that created it disconnects. Persistent is optional. Defaults to false
	#
	# @example
	#  dict["key1"] = ["value1", true] #adds value1 to dict["key1"] with persistent = true
	#  dict["key2"] = ["value2", false] #adds value2 to dict["key2"] with persistent = false
	#  dict["key3"] = ["value3"] #adds value to to dict["key3"] with the default persistent = false
	#  dict["key1"] = nil #removes the value of dict["key1"]
	#
	# @return [Boolean] returns true or raises an error

	def []=(key, value=nil)  

      # If we are assigning something to nil, let's remove it
      if value.nil?
        delete(key)
        sleep @key_sleep.to_f
        nil
      else
	    persistent = (value[:persistent].nil? ? 0 : (value[:persistent] ? 1 : 0))
	  
        Klass.addKey(@handle, key.to_s, value[:value].to_s, persistent)
        sleep @key_sleep.to_f
        value[:value].to_s
      end
    end
    alias_method :add, :[]=
    alias_method :put, :[]=
    
	# @return [String] returns the key value. If more than one key matches, only the first value is returned, or raises an error.
    def [](key)
      ptr = ::FFI::MemoryPointer.new(:string, 8192)
      Klass.getKey(@handle, key, ptr, 8192)
      ptr.get_string(0)
    end
    alias_method :get, :[]

	# Removes a set of keys from the dictionary
    # 
    # @return [Boolean] returns true or raises an error
	def delete(pattern)      
      Klass.removeKey(@handle, (pattern.kind_of?(Regexp) ? pattern.source : pattern.to_s))
      true
    end
    
    # Sets a server connect handler callback function. This is called when a connection to the server has been made.
    #
    # @param [String] obj Object to pass to the callback function. This is optional.
    # @param [Proc] Block When the callback is executed, the device and object are yielded to this block.
    # @example
    #     dict.on_connect do |obj|
    #       puts 'Connected'
    #     end
    # As this runs in it's own thread, be sure that all errors are properly handled or the thread will halt and not fire any more.
    # @return [Boolean] returns true or raises an error
    def on_connect(obj=nil, &block)
      @on_connect_obj = obj
      @on_connect = Proc.new { |handle, obj_ptr|
        # On connect, we'll need to re-add all of our change handlers
        @listeners.each_pair do |pattern, (listener, proc)|
          begin
            next if status != :connected
            Klass.set_OnKeyChange_Handler(@handle, listener, pattern, proc, pointer_for(obj))              
            sleep @handler_sleep
          rescue
            Phidgets::Log.error("#{self.class}::on_connect", $!.to_s)
          end
        end
        yield self, object_for(obj_ptr)
      }
      Klass.set_OnServerConnect_Handler(@handle, @on_connect, pointer_for(obj))
      sleep @handler_sleep
    end
    
    # Sets a server disconnect handler callback function. This is called when a connection to the server has been lost.
    #
    # @param [String] obj Object to pass to the callback function. This is optional.
    # @param [Proc] Block When the callback is executed, the device and object are yielded to this block.
    # @example
    #     dict.on_disconnect do |obj|
    #       puts 'Disconnected'
    #     end
    # As this runs in it's own thread, be sure that all errors are properly handled or the thread will halt and not fire any more.
    # @return [Boolean] returns true or raises an error
    def on_disconnect(obj=nil, &block)
      @on_disconnect_obj = obj
      @on_disconnect = Proc.new { |handle, obj_ptr|
        # On disconnect, we'll need to remove all of our change handlers
        @listeners.each_pair do |pattern, (listener, proc)|
          Klass.remove_OnKeyChange_Handler(listener.get_pointer(0))
          sleep @handler_sleep
        end
        yield self, object_for(obj_ptr)
      }
      Klass.set_OnServerDisconnect_Handler(@handle, @on_disconnect, pointer_for(obj))
      sleep @handler_sleep
    end
    
    # Sets a error handler callback function. This is called when an asynchronous error occurs.
    #
    # @param [String] obj Object to pass to the callback function. This is optional.
    # @param [Proc] Block When the callback is executed, the device and object are yielded to this block.
    # @example
    #     dict.on_error do |obj|
    #       puts "Error (#{code}): #{reason}"
    #     end
    # As this runs in it's own thread, be sure that all errors are properly handled or the thread will halt and not fire any more.
    # @return [Boolean] returns true or raises an error
    def on_error(obj=nil, &block)
      @on_error_obj = obj
      @on_error = Proc.new { |handle, obj_ptr, code, error|
        yield object_for(obj_ptr), code, error
      }
      Klass.set_OnError_Handler(@handle, @on_error, pointer_for(obj))
      sleep @handler_sleep
    end

    # Adds a key listener to an opened dictionary. Note that this should only be called after the connection has been made - unlike all other events.
    #
    # @param [String] obj Object to pass to the callback function. This is optional.
    # @param [Proc] Block When the callback is executed, the device and object are yielded to this block.
    # @example
    #     dict.on_change do |obj, key, val, reason|
    #       puts "Every key: #{key} => #{val}-- #{reason}"
    #     end
    # As this runs in it's own thread, be sure that all errors are properly handled or the thread will halt and not fire any more.
    # @return [Boolean] returns true or raises an error
    def on_change(pattern=".*", obj=nil, &block)
      pattern = (pattern.kind_of?(Regexp) ? pattern.source : pattern.to_s)

      @listeners[pattern] = [
        ::FFI::MemoryPointer.new(:pointer),
        Proc.new { |handle, obj_ptr, key, value, reason|
          yield object_for(obj_ptr), key, value, reason
        }
      ]
      Klass.set_OnKeyChange_Handler(@handle, @listeners[pattern][0], pattern, @listeners[pattern][1], pointer_for(obj))
      sleep @handler_sleep
    end

	# Removes a key listener
	# @param [String] pattern pattern
	# @return [Boolean] returns true or raises an error
    def remove_on_change(pattern=".*")
      pattern = (pattern.kind_of?(Regexp) ? pattern.source : pattern.to_s)
      if @listeners.has_key?(pattern)
        listener, proc = @listeners.delete(pattern)
        Klass.remove_OnKeyChange_Handler(listener.get_pointer(0))
        sleep @handler_sleep
        true
      else
        nil
      end
    end

	# @return [Array] returns all the keys in the dictionary or raises an error    
    def listeners
      @listeners.keys
    end

	# @return [Strings] returns the server ID, or raises an error    
    def server_id
      ptr = ::FFI::MemoryPointer.new(:string)
      Klass.getServerID(@handle, ptr)
      ptr.get_string(0)
    end

	# @return [String] returns the connected to server status, or raises an error    
    def status
      ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getServerStatus(@handle, ptr)
      Phidgets::FFI::ServerStatus[ptr.get_int(0)]
    end

	# @return [String, Integer] returns the address and port, or raises an error    
    def server_address
      str_ptr, int_ptr = ::FFI::MemoryPointer.new(:string), ::FFI::MemoryPointer.new(:int)
      Klass.getServerAddress(@handle, str_ptr, int_ptr)
      strPtr = str_ptr.get_pointer(0)
      address = (strPtr.null? ? nil : strPtr.read_string)
      port = int_ptr.get_int(0)
      [address, port]
    end
  end
end