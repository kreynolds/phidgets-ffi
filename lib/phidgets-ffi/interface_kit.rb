module Phidgets

  # This class represents a PhidgetInterfaceKit.
  class InterfaceKit
 
    Klass = Phidgets::FFI::CPhidgetInterfaceKit
    include Phidgets::Common
    
	# Collection of digital inputs
	# @return [InterfaceKitInputs] 
    attr_reader :inputs
	
	# Collection of digital outputs
	# @return [InterfaceKitOutputs] 
	attr_reader :outputs
	
	# Collection of analog sensor inputs
	# @return [InterfaceKitSensors] 
	attr_reader :sensors
	
	attr_reader :attributes
    
	# The attributes of a PhidgetInterfaceKit
	def attributes
      super.merge({
        :inputs => inputs.size,
        :outputs => outputs.size,
        :sensors => sensors.size,
		:ratiometric => ratiometric
      })
    end

    # Sets an input change handler callback function. This is called when a digital input on the PhidgetInterfaceKit board has changed.
    #
    # @param [String] obj Object to pass to the callback function. This is optional.
    # @param [Proc] Block When the callback is executed, the device and object are yielded to this block.
    # @example
    #     ifkit.on_input_change do |device, input, state, obj|
    #       print "Digital Input  #{input.index}, changed to #{state}\n"
    #     end
    # As this runs in it's own thread, be sure that all errors are properly handled or the thread will halt and not fire any more.
    # @return [Boolean] returns true or raises an error
    def on_input_change(obj=nil, &block)
      @on_input_change_obj = obj
      @on_input_change = Proc.new { |device, obj_ptr, index, state|
        yield self, @inputs[index], (state == 0 ? false : true), object_for(obj_ptr)
      }
      Klass.set_OnInputChange_Handler(@handle, @on_input_change, pointer_for(obj))
    end
    
    # Sets an output change handler callback function. This is called when a digital output on the PhidgetInterfaceKit board has changed.
    #
    # @param [String] obj Object to pass to the callback function. This is optional.
    # @param [Proc] Block When the callback is executed, the device and object are yielded to this block.
    # @example
    #     ifkit.on_output_change do |device, output, state, obj|
    #       print "Digital Output  #{output.index}, changed to #{state}\n"
    #     end
    # As this runs in it's own thread, be sure that all errors are properly handled or the thread will halt and not fire any more.
    # @return [Boolean] returns true or raises an error
    def on_output_change(obj=nil, &block)
      @on_output_change_obj = obj
      @on_output_change = Proc.new { |device, obj_ptr, index, state|
        yield self, @outputs[index], (state == 0 ? false : true), object_for(obj_ptr)
      }
      Klass.set_OnOutputChange_Handler(@handle, @on_output_change, pointer_for(obj))
    end
    
    # Sets a sensor change handler callback function. This is called when a sensor on the PhidgetInterfaceKit has changed by at least the sensitivity value that has been set for this input.
    #
    # @param [String] obj Object to pass to the callback function. This is optional.
    # @param [Proc] Block When the callback is executed, the device and object are yielded to this block.
    # @example
    #     ifkit.on_sensor_change do |device, input, value, obj|
    #       print "Analog Input  #{input.index}, changed to #{value}\n"
    #     end
    # As this runs in it's own thread, be sure that all errors are properly handled or the thread will halt and not fire any more.
    # @return [Boolean] returns true or raises an error
    def on_sensor_change(obj=nil, &block)
	  @on_sensor_change_obj = obj
      @on_sensor_change = Proc.new { |device, obj_ptr, index, value|
	    yield self, @sensors[index], value, object_for(obj_ptr)
	}
      Klass.set_OnSensorChange_Handler(@handle, @on_sensor_change, pointer_for(obj))
    end
	
    # Returns the ratiometric state of the Phidget.
    #
    # @return [Boolean] returns the ratiometric state or raises an error
    def ratiometric
      ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getRatiometric(@handle, ptr)
      (ptr.get_int(0) == 0) ? false : true
    end
    alias_method :ratiometric?, :ratiometric

    # Sets the ratiometric state of the Phidget.
    # @param [Boolean] new_state new ratiometric state
    # @return [Boolean] returns the ratiometric state or raises an error
    def ratiometric=(new_state)
      tmp = new_state ? 1 : 0
      Klass.setRatiometric(@handle, tmp)
      new_state
    end
		
	 # This class represents an digital input for a PhidgetInterfaceKit. All the properties of an digital input are stored in this class.  
	class InterfaceKitInputs

	Klass = Phidgets::FFI::CPhidgetInterfaceKit
    
	private
	def initialize(handle, index)
      @handle, @index = handle, index.to_i
	end

	public

	# Displays data for the digital input
    def inspect
      "#<#{self.class} @index=#{index}, @state=#{state}>"
    end

	# @return [Integer] returns index of the digital input, or raises an error.
	def index 
		@index
	end
	
	# @return [Boolean] returns state of the digital input, or raises an error.
    def state
      ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getInputState(@handle, @index, ptr)
      (ptr.get_int(0) == 0) ? false : true
    end
	
	# @return [Boolean] returns true if the state is true.
    def on
      state == true
    end
	alias_method :on?, :on
    
	# @return [Boolean] returns true if the state is off.
    def off
      !on
    end
    alias_method :off?, :off
	
  end

  # This class represents an digital output for a PhidgetInterfaceKit. All the properties of an digital output are stored and modified in this class.
  class InterfaceKitOutputs
    Klass = Phidgets::FFI::CPhidgetInterfaceKit

	private
    def initialize(handle, index)
      @handle, @index = handle, index.to_i
    end

	public
	
	# Displays data for the digital output
    def inspect
      "#<#{self.class} @index=#{index}, @state=#{state}>"
    end
	
    # @return [Integer] returns index of the digital output, or raises an error.
	def index 
		@index
	end
	
	# Sets the state of the digital output, or raises an error.
	# @param [Boolean] new_state new state
	# @return [Boolean] sets the state of the digital output, or raises an error.
	def state=(new_state)
      tmp = new_state ? 1 : 0
      Klass.setOutputState(@handle, @index, tmp)
      new_state
    end

	# @return [Boolean] returns state of the digital output, or raises an error.
    def state
      ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getOutputState(@handle, @index, ptr)
      (ptr.get_int(0) == 0) ? false : true
    end

	# @return [Boolean] returns true if the state is true.
    def on
      state == true
    end
	alias_method :on?, :on
    
	# @return [Boolean] returns true if the state is off.
    def off
      !on
    end
    alias_method :off?, :off
  end
 
  # This class represents an analog sensor for a PhidgetInterfaceKit. All the properties of an analog sensor are stored and modified in this class.
  class InterfaceKitSensors
    Klass = Phidgets::FFI::CPhidgetInterfaceKit

	private
    def initialize(handle, index)
      @handle, @index = handle, index.to_i
    end
	
	public
	
	# Displays data for the analog sensor
    def inspect
      "#<#{self.class} @value=#{value}, @raw_value=#{raw_value}, @data_rate=#{data_rate}, @sensitivity=#{sensitivity}, @data_rate_max=#{data_rate_max}, @data_rate_min=#{data_rate_min}>"
    end

	# @return [Integer] returns index of the analog input, or raises an error.
	def index 
		@index
	end
	
	# @return [Integer] returns value of the analog input, or raises an error.
    def value
      ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getSensorValue(@handle, @index, ptr)
      ptr.get_int(0)
    end
    alias_method :to_i, :value

	# @return [Integer] returns raw value of the analog input, or raises an error.
    def raw_value
      ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getSensorRawValue(@handle, @index, ptr)
      ptr.get_int(0)
    end

	# @return [Integer] returns sensitivity of the analog input, or raises an error.
    def sensitivity
      ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getSensorChangeTrigger(@handle, @index, ptr)
      ptr.get_int(0)
    end

	# Sets the sensitivity of the analog input, or raises an error.
	# @param [Integer] new_sensitivity new sensitivity
	# @return [Integer] returns sensitivity of the analog input, or raises an error.
    def sensitivity=(new_sensitivity)
      Klass.setSensorChangeTrigger(@handle, @index, new_sensitivity.to_i)
      new_sensitivity.to_i
    end
		
	# @return [Integer] returns data rate of the analog input, or raises an error.
    def data_rate
      ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getDataRate(@handle, @index, ptr)
      ptr.get_int(0)
    end

	# Sets the data rate of the analog input, or raises an error.
	# @param [Integer] new_data_rate data rate
	# @return [Integer] returns the data rate of the analog input, or raises an error.
    def data_rate=(new_data_rate)
      Klass.setDataRate(@handle, @index, new_data_rate.to_i)
      new_data_rate.to_i
    end
	
	# @return [Integer] returns minimum data rate of the analog input, or raises an error.
    def data_rate_min
      ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getDataRateMin(@handle, @index, ptr)
      ptr.get_int(0)
    end

	# @return [Integer] returns maximum data rate of the analog input, or raises an error.
    def data_rate_max
      ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getDataRateMax(@handle, @index, ptr)
      ptr.get_int(0)
    end
	
  end #InterfaceKitSensors
    
	private
    
	def load_device_attributes
		load_inputs
		load_outputs
		load_sensors
	end
	
    def load_inputs
      ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getInputCount(@handle, ptr)

      @inputs = []
      ptr.get_int(0).times do |i|
        @inputs << InterfaceKitInputs.new(@handle, i)
      end
    end
	
    def load_outputs
		ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getOutputCount(@handle, ptr)

      @outputs = []
      ptr.get_int(0).times do |i|
        @outputs << InterfaceKitOutputs.new(@handle, i)
      end
    end

    def load_sensors
      ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getSensorCount(@handle, ptr)
      @sensors = []
      ptr.get_int(0).times do |i|
        @sensors << InterfaceKitSensors.new(@handle, i)
      end
    end
	
	def remove_specific_event_handlers
	   Klass.set_OnSensorChange_Handler(@handle, nil, nil)
	   Klass.set_OnOutputChange_Handler(@handle, nil, nil)
	   Klass.set_OnInputChange_Handler(@handle, nil, nil)
	end
  end
   
end