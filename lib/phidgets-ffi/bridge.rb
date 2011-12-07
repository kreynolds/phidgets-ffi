module Phidgets

  # This class represents a PhidgetBridge.
  class Bridge
 
    Klass = Phidgets::FFI::CPhidgetBridge
    include Phidgets::Common
    
	# Collection of bridge inputs
	# @return [BridgeInputs] 
    attr_reader :inputs
	
	attr_reader :attributes
		
	# The attributes of a PhidgetBridge
    def attributes
      super.merge({
        :inputs => inputs.size,
      })
    end

    # Sets a bridge data handler callback function. This is called at a set rate as defined by {Phidgets::Bridge#data_rate}
    #
    # @param [String] obj Object to pass to the callback function. This is optional.
    # @param [Proc] Block When the callback is executed, the device and object are yielded to this block.
    # @example
    #     bridge.on_bridge_data do |device, input, value, obj|
    #       puts "Bridge Index  #{input.index}, value: #{value}"
    #     end
    # As this runs in it's own thread, be sure that all errors are properly handled or the thread will halt and not fire any more.
    # @return [Boolean] returns true or raises an error
    def on_bridge_data(obj=nil, &block)
	
      @on_bridge_data_obj = obj
      @on_bridge_data = Proc.new { |device, obj_ptr, index, value|
	    yield self, @inputs[index], value, object_for(obj_ptr)

	}
      Klass.set_OnBridgeData_Handler(@handle, @on_bridge_data, pointer_for(obj))
    end

	# @return [Integer] returns the data rate of the board, in milliseconds, or raises an error.
    def data_rate
      ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getDataRate(@handle, ptr)
      ptr.get_int(0)
    end

	# Sets the data rate of the board, or raises an error.
	# @param [Integer] new_data_rate data rate, in millilseconds
	# @return [Integer] returns the data rate of the board, or raises an error.
    def data_rate=(new_data_rate)
      Klass.setDataRate(@handle, new_data_rate.to_i)
      new_data_rate.to_i
    end
	
	# @return [Integer] returns maximum data rate of the board, in milliseconds, or raises an error.
    def data_rate_max
      ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getDataRateMax(@handle, ptr)
      ptr.get_int(0)
    end
	
	# @return [Integer] returns minimum data rate of the board, in milliseconds, or raises an error.
    def data_rate_min
      ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getDataRateMin(@handle, ptr)
      ptr.get_int(0)
    end
	
  # This class represents a bridge input for a PhidgetBridge. All the properties of an bridge input are stored and modified in this class.
  class BridgeInputs
    Klass = Phidgets::FFI::CPhidgetBridge

	private
    def initialize(handle, index)
      @handle, @index = handle, index.to_i
    end

	public
	# Displays data for the bridge input.
    def inspect
      "#<#{self.class} @index=#{index}, @bridge_value=#{bridge_value}, @bridge_min=#{bridge_min}, @bridge_max=#{bridge_max}, @enabled=#{enabled}, @gain=#{gain}>"
	end

	# @return [Integer] returns the index of the bridge input, or raises an error.
	def index 
		@index
	end
	
	# @return [Float] returns the value of a bridge input, in mV/V, or raises an error.
    def bridge_value
      ptr = ::FFI::MemoryPointer.new(:double)
      Klass.getBridgeValue(@handle, @index, ptr)
      ptr.get_double(0)
    end

	# @return [Float] returns the maximum supported input value, in mV/V, or raises an error.
    def bridge_max
      ptr = ::FFI::MemoryPointer.new(:double)
      Klass.getBridgeMax(@handle, @index, ptr)
      ptr.get_double(0)
    end

	# @return [Float] returns the minimum supported input value, in mV/V, or raises an error.
    def bridge_min
      ptr = ::FFI::MemoryPointer.new(:double)
      Klass.getBridgeMin(@handle, @index, ptr)
      ptr.get_double(0)
    end
	
	# @return [Boolean] returns the enabled state of a bridge input, or raises an error.
    def enabled
      ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getEnabled(@handle, @index, ptr)
      (ptr.get_int(0) == 0) ? false : true
    end

	# Sets the enabled state of a bridge input, or raises an error.
	# @param [Boolean] new_state new state
	# @return [Boolean] returns the enabled state of a bridge input, or raises an error.
    def enabled=(new_state)
      tmp = new_state ? 1 : 0
      Klass.setEnabled(@handle, @index, tmp)
      new_state
    end

	# @return [Phidgets::FFI::BridgeGains] returns the gain type of a bridge input, or raises an error.
	def gain
      ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getGain(@handle, @index, ptr)
      Phidgets::FFI::BridgeGains[ptr.get_int(0)]
    end

	# Sets the gain type of a bridge input, or raises an error. 
	# @param [Phidgets::FFI::BridgeGains] new_gain new gain
	# @return [Phidgets::FFI::BridgeGains] returns the gain type of a bridge input, or raises an error.
    def gain=(new_gain)
      ptr = ::FFI::MemoryPointer.new(:int)
      Klass.setGain(@handle, @index, Phidgets::FFI::BridgeGains[new_gain])
      new_gain
    end

  end #BridgeInputs
  
	private
    
	def load_device_attributes
	  load_inputs
	end

    def load_inputs
	  ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getInputCount(@handle, ptr)
      @inputs = []
      ptr.get_int(0).times do |i|
        @inputs << BridgeInputs.new(@handle, i)
      end

    end
	
	def remove_specific_event_handlers
	   Klass.set_OnBridgeData_Handler(@handle, nil, nil)
	end
  end

end