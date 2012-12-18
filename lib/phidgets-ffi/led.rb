module Phidgets

  # This class represents a PhidgetLED.
  class LED
 
    Klass = Phidgets::FFI::CPhidgetLED
    include Phidgets::Common
    
	# Collection of LEDs
	# @return [LEDOuputs] 
    attr_reader :leds
	
	attr_reader :attributes
		
	# The attributes of a PhidgetLED
    def attributes
      super.merge({
        :leds => leds.size,
      })
    end

	# @return [Phidgets::FFI::LEDCurrentLimit] returns the board current limit for all LEDs, or raises an error. Not supported on all PhidgetLEDs.
	def current_limit
      ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getCurrentLimit(@handle, ptr)
      Phidgets::FFI::LEDCurrentLimit[ptr.get_int(0)]
    end

	# Sets the board current limit for all LEDs, or raises an error. Not supported on all PhidgetLEDs.
	# @param [Phidgets::FFI::LEDCurrentLimit] new_current_limit new current limit
	# @return [Phidgets::FFI::LEDCurrentLimit] returns the board current limit, or raises an error.
    def current_limit=(new_current_limit)
      ptr = ::FFI::MemoryPointer.new(:int)
      Klass.setCurrentLimit(@handle, Phidgets::FFI::LEDCurrentLimit[new_current_limit])
      new_current_limit
    end

	# @return [Phidgets::FFI::LEDVoltage] returns the voltage level for all LEDs, or raises an error. Not supported on all PhidgetLEDs.
	def voltage
      ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getVoltage(@handle, ptr)
      Phidgets::FFI::LEDVoltage[ptr.get_int(0)]
    end

	# Sets the voltage level for all LEDs, or raises an error. Not supported on all PhidgetLEDs.
	# @param [Phidgets::FFI::LEDVoltage] new_voltage new voltage
	# @return [Phidgets::FFI::LEDVoltage] returns the voltage level, or raises an error.
    def voltage=(new_voltage)
      ptr = ::FFI::MemoryPointer.new(:int)
      Klass.setVoltage(@handle, Phidgets::FFI::LEDVoltage[new_voltage])
      new_voltage
    end
	
  # This class represents an led for a PhidgetLED. All the properties of an led are stored and modified in this class.
  class LEDOuputs
    Klass = Phidgets::FFI::CPhidgetLED

	private
    def initialize(handle, index)
      @handle, @index = handle, index.to_i
    end

	public
	# Displays data for an led.
    def inspect
      "#<#{self.class} @index=#{index}, @brightness=#{brightness}>"
	end

	# @return [Integer] returns the index of the led, or raises an error.
	def index 
		@index
	end
	
	# @return [Float] returns the brightness level of an LED, or raises an error.
    def brightness
      ptr = ::FFI::MemoryPointer.new(:double)
      Klass.getBrightness(@handle, @index, ptr)
      ptr.get_int(0)
    end

	# Sets the brightness level of an LED, or raises an error. Brightness levels range from 0-100
	# @param [Float] new_brightness new brightness
	# @return [Float] returns the brightness of an LED, or raises an error.
    def brightness=(new_brightness)
      Klass.setBrightness(@handle, @index, new_brightness.to_f)
      new_brightness.to_f
    end
	
	# @return [Float] returns the current limit of an LED, or raises an error.
    def current_limit
      ptr = ::FFI::MemoryPointer.new(:double)
      Klass.getCurrentLimitIndexed(@handle, @index, ptr)
      ptr.get_int(0)
    end

	# Sets the current limit of an LED, or raises an error. Current Limit levels range from 0-80 mA
	# @param [Float] new_current_limit new current limit
	# @return [Float] returns the current limit of an LED, or raises an error.
    def current_limit=(new_current_limit)
      Klass.setCurrentLimitIndexed(@handle, @index, new_current_limit.to_f)
      new_current_limit.to_f
    end
	
  end #LEDOutputs
  
	private
    
	def load_device_attributes
	  load_leds
	end

    def load_leds
	  ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getLEDCount(@handle, ptr)
      @leds = []
      ptr.get_int(0).times do |i|
        @leds << LEDOuputs.new(@handle, i)
      end

    end
	
	def remove_specific_event_handlers
	 
	end
  end

end