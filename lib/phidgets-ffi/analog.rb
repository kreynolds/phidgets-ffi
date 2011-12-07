module Phidgets

  # This class represents a PhidgetAnalog.
  class Analog
 
    Klass = Phidgets::FFI::CPhidgetAnalog
    include Phidgets::Common
    
	# Collection of analog outputs
	# @return [AnalogOutputs] 
    attr_reader :outputs
	
	attr_reader :attributes
	
	# The attributes of a PhidgetAnalog
    def attributes
      super.merge({
		  :outputs => outputs.size
      })
    end

	private
    
	def load_device_attributes
		load_outputs
	end

    def load_outputs
	  ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getOutputCount(@handle, ptr)
      @outputs = []
      ptr.get_int(0).times do |i|
        @outputs << AnalogOutputs.new(@handle, i)
      end
    end

	def remove_specific_event_handlers

	end
  
  # This class represents an analog output for a PhidgetAnalog. All the properties of an output are stored and modified in this class.
  class AnalogOutputs
    Klass = Phidgets::FFI::CPhidgetAnalog
	
	private
    def initialize(handle, index)
      @handle, @index = handle, index.to_i
    end

	public

    # Displays data for the analog output
    def inspect
      "#<#{self.class} @index=#{index}, @enabled=#{enabled}, @voltage=#{voltage}, @voltage_min=#{voltage_min}, @voltage_max=#{voltage_max}>"
	end

	# @return [Integer] returns the index of an output, or raises an error.
	def index 
		@index
	end
	
	
	# @return [Boolean] returns the enabled state of an output, or raises an error.
    def enabled
      ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getEnabled(@handle, @index, ptr)
      (ptr.get_int(0) == 0) ? false : true
    end

	# Sets the enabled state of an output, or raises an error.
	# @param [Boolean] new_state new state
	# @return [Boolean] returns the enabled state of an output, or raises an error.
    def enabled=(new_state)
      tmp = new_state ? 1 : 0
      Klass.setEnabled(@handle, @index, tmp)
      new_state
    end
	
	# @return [Float] returns the voltage of an output, in V, or raises an error.
    def voltage
      ptr = ::FFI::MemoryPointer.new(:double)
      Klass.getVoltage(@handle, @index, ptr)
      ptr.get_double(0)
    end
	
	# Sets the voltage of an output, in V, or raises an error.
	# @param [Float] new_voltage new voltage
	# @return [Float] returns the voltage of an output, in V, or raises an error.
    def voltage=(new_voltage)
      Klass.setVoltage(@handle, @index, new_voltage.to_f)
      new_voltage
    end	
	
	# @return [Float] returns the minimum supported output voltage, or raises an error.
    def voltage_min
      ptr = ::FFI::MemoryPointer.new(:double)
      Klass.getVoltageMin(@handle, @index, ptr)
      ptr.get_double(0)
    end

	# @return [Float] returns the maximum supported output voltage, or raises an error.
    def voltage_max
      ptr = ::FFI::MemoryPointer.new(:double)
      Klass.getVoltageMax(@handle, @index, ptr)
      ptr.get_double(0)
    end

  end
  end
 end
  
