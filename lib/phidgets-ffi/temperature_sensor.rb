module Phidgets

  # This class represents a PhidgetTemperatureSensor.
  class TemperatureSensor
 
    Klass = Phidgets::FFI::CPhidgetTemperatureSensor
    include Phidgets::Common
    
	# Collection of temperature sensor sensors
	# @return [TemperatureSensorSensors] 
    attr_reader :thermocouples
	
	attr_reader :attributes
    
	# The attributes of a PhidgetTemperatureSensor
	def attributes
      super.merge({
        :thermocouples => thermocouples.size,
      })
    end

    # Sets a temperature change handler callback function. This is called when when the temperature has changed atleast by the sensitivity value that has been set.
    #
    # @param [String] obj Object to pass to the callback function. This is optional.
    # @param [Proc] Block When the callback is executed, the device and object are yielded to this block.
    # @example
    #     temp.on_temperature_change do |device, input, temperature, obj|
    #       puts "Input #{input.index}'s temperature changed to #{temperature}"
    #     end
    # As this runs in it's own thread, be sure that all errors are properly handled or the thread will halt and not fire any more.
    # @return [Boolean] returns true or raises an error
    def on_temperature_change(obj=nil, &block)
      @on_temperature_change_obj = obj
      @on_temperature_change = Proc.new { |device, obj_ptr, index, temperature|
	    yield self, @thermocouples[index], temperature, object_for(obj_ptr)
	}
      Klass.set_OnTemperatureChange_Handler(@handle, @on_temperature_change, pointer_for(obj))
    end

 
  # This class represents a thermocouple sensor attached for a PhidgetTemperatureSensor. All the properties of an thermocouple sensor are stored and modified in this class.
  class TemperatureSensorSensors
    Klass = Phidgets::FFI::CPhidgetTemperatureSensor

	private
    def initialize(handle, index)
      @handle, @index = handle, index.to_i
    end
	
	public
	# Displays data for the thermocouple sensor.
    def inspect
      "#<#{self.class} @index=#{index}, @sensitivity=#{sensitivity}, @temperature_min=#{temperature_min}, @temperature_max=#{temperature_max}, @type=#{type}>"
	end
	
	# @return [Integer] returns index of the thermocouple sensor, or raises an error.
	def index 
		@index
	end
	
	# @return [Float] returns the potential of the thermocouple sensor, in mV, or raises an error.
    def potential
      ptr = ::FFI::MemoryPointer.new(:double)
      Klass.getPotential(@handle, @index, ptr)
      ptr.get_double(0)
    end

	# @return [Float] returns the smallest potential that the thermocouple sensor can return, in mV, or raises an error.
    def potential_min
      ptr = ::FFI::MemoryPointer.new(:double)
      Klass.getPotentialMin(@handle, @index, ptr)
      ptr.get_double(0)
    end

	# @return [Float] returns the largest potential that the thermocouple sensor can return, in mV, or raises an error.
    def potential_max
      ptr = ::FFI::MemoryPointer.new(:double)
      Klass.getPotentialMax(@handle, @index, ptr)
      ptr.get_double(0)
    end
	
	# @return [Float] returns the temperature change trigger sensitivity for the thermocouple sensor, or raises an error.
    def sensitivity
      ptr = ::FFI::MemoryPointer.new(:double)
      Klass.getTemperatureChangeTrigger(@handle, @index, ptr)
      ptr.get_double(0)
    end
	
	# Sets the temperature change trigger sensitivity of the thermocouple sensor, or raises an error.
	# @param [Float] new_senstivity new sensitivity
	# @return [Float] returns the temperature change trigger sensitivity of the thermocouple sensor, or raises an error.
    def sensitivity=(new_sensitivity)
      Klass.setTemperatureChangeTrigger(@handle, @index, new_sensitivity.to_f)
      new_sensitivity
    end

	# @return [Float] returns the temperature of the thermocouple sensor, in degrees celcius, or raises an error.
    def temperature
      ptr = ::FFI::MemoryPointer.new(:double)
      Klass.getTemperature(@handle, @index, ptr)
      ptr.get_double(0)
    end
	
	# @return [Float] returns the minimum temperature value that the thermocouple sensor can return, in degrees celcius, or raises an error.
    def temperature_min
      ptr = ::FFI::MemoryPointer.new(:double)
      Klass.getTemperatureMin(@handle, @index, ptr)
      ptr.get_double(0)
    end

	# @return [Float] returns the maximum temperature value that the thermocouple sensor can return, in degrees celcius, or raises an error.
    def temperature_max
      ptr = ::FFI::MemoryPointer.new(:double)
      Klass.getTemperatureMax(@handle, @index, ptr)
      ptr.get_double(0)
    end
	
	# @return [Phidgets::FFI::TemperatureSensorThermocoupleTypes] returns the thermocouple type of the thermocouple sensor, or raises an error.
	def type
      ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getThermocoupleType(@handle, @index, ptr)
      Phidgets::FFI::TemperatureSensorThermocoupleTypes[ptr.get_int(0)]
    end
  
	# Sets the thermocouple type of the thermocouple sensor, or raises an error. 
	# @param [Phidgets::FFI::TemperatureSensorThermocoupleTypes] new_type new type
	# @return [Phidgets::FFI::TemperatureSensorThermocoupleTypes] returns the thermocouple type of the thermocouple sensor, or raises an error.
    def type=(new_type)
      ptr = ::FFI::MemoryPointer.new(:int)
      Klass.setThermocoupleType(@handle, @index, Phidgets::FFI::TemperatureSensorThermocoupleTypes[new_type])
      new_type
    end
	
  end #TemperatureSensorSensors
    
	private
    
	def load_device_attributes
		load_thermocouples
	end
	
    def load_thermocouples
      ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getTemperatureInputCount(@handle, ptr)

      @thermocouples = []
      ptr.get_int(0).times do |i|
        @thermocouples << TemperatureSensorSensors.new(@handle, i)
      end
    end
	
	def remove_specific_event_handlers
	   Klass.set_OnTemperatureChange_Handler(@handle, nil, nil)
	end
  end
   
end