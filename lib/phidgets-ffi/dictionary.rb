module Phidgets
  class Dictionary

    Klass = Phidgets::FFI::CPhidgetDictionary
    include Utility
    
    def initialize(options={}, &block)
      @listeners = {}
      @options = {:address => 'localhost', :port => 5001, :server_id => nil, :password => nil}.merge(options)

      create
      if block_given?
        open(@options)
        yield self
        close
        delete_dict
      end
    end

    def create
      ptr = ::FFI::MemoryPointer.new(:pointer, 1)
      Klass.create(ptr)        
      @handle = ptr.get_pointer(0)
      true
    end

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
    
    def close
      Klass.close(@handle)
      true
    end

    def delete_dict
      Klass.delete(@handle)
      true
    end
    
    def []=(key, val, persistent=false)      
      # If we are assigning something to nil, let's remove it
      if val.nil?
        delete(key)
      else
        persistent = (persistent ? 1 : 0)
        Klass.addKey(@handle, key.to_s, val.to_s, persistent)
        val.to_s
      end
    end
    alias_method :add, :[]=
    alias_method :put, :[]=
    
    def [](key)
      ptr = ::FFI::MemoryPointer.new(:string, 8192)
      Klass.getKey(@handle, key, ptr, 8192)
      ptr.get_string(0)
    end
    alias_method :get, :[]

    def delete(pattern)      
      Klass.removeKey(@handle, (pattern.kind_of?(Regexp) ? pattern.source : pattern.to_s))
      true
    end
    
    def on_connect(obj=nil, &block)
      @on_connect_obj = obj
      @on_connect = Proc.new { |handle, obj_ptr|
        # On connect, we'll need to re-add all of our change handlers
        @listeners.each_pair do |pattern, (listener, proc)|
          begin
            next if status != :connected
            Klass.set_OnKeyChange_Handler(@handle, listener, pattern, proc, pointer_for(obj))              
            sleep 0.5
          rescue
            Phidgets::Log.error("#{self.class}::on_connect", $!.to_s)
          end
        end
        yield object_for(obj_ptr)
      }
      Klass.set_OnServerConnect_Handler(@handle, @on_connect, pointer_for(obj))
    end
    
    def on_disconnect(obj=nil, &block)
      @on_disconnect_obj = obj
      @on_disconnect = Proc.new { |handle, obj_ptr|
        # On disconnect, we'll need to remove all of our change handlers
        @listeners.each_pair do |pattern, (listener, proc)|
          Klass.remove_OnKeyChange_Handler(listener.get_pointer(0))
        end
        yield object_for(obj_ptr)
      }
      Klass.set_OnServerDisconnect_Handler(@handle, @on_disconnect, pointer_for(obj))
    end
    
    def on_error(obj=nil, &block)
      @on_error_obj = obj
      @on_error = Proc.new { |handle, obj_ptr, code, error|
        yield object_for(obj_ptr), code, error
      }
      Klass.set_OnError_Handler(@handle, @on_error, pointer_for(obj))
    end


    def on_change(pattern=".*", obj=nil, &block)
      pattern = (pattern.kind_of?(Regexp) ? pattern.source : pattern.to_s)
      @listeners[pattern] = [
        ::FFI::MemoryPointer.new(:pointer),
        Proc.new { |handle, obj_ptr, key, value, reason|
          yield object_for(obj_ptr), key, value, reason
        }
      ]
      Klass.set_OnKeyChange_Handler(@handle, @listeners[pattern][0], pattern, @listeners[pattern][1], pointer_for(obj))
      sleep 0.5
    end

    def remove_on_change(pattern)
      pattern = (pattern.kind_of?(Regexp) ? pattern.source : pattern.to_s)
      if @listeners.has_key?(pattern)
        listener, proc = @listeners.delete(pattern)
        Klass.remove_OnKeyChange_Handler(listener.get_pointer(0))
        sleep 0.5
        true
      else
        nil
      end
    end
    
    def listeners
      @listeners.keys
    end

    def server_id
      ptr = ::FFI::MemoryPointer.new(:string)
      Klass.getServerID(@handle, ptr)
      ptr.get_string(0)
    end

    def status
      ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getServerStatus(@handle, ptr)
      Phidgets::FFI::ServerStatus[ptr.get_int(0)]
    end

    def server_address
      str_ptr, int_ptr = ::FFI::MemoryPointer.new(:string), ::FFI::MemoryPointer.new(:int)
      Klass.getServerID(@handle, str_ptr, int_ptr)
      strPtr = str_ptr.get_pointer(0)
      address = (strPtr.null? ? nil : strPtr.read_string)
      port = int_ptr.get_int(0)
      [address, port]
    end
  end
end