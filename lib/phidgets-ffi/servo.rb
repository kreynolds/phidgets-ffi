module Phidgets

  # This class represents a PhidgetServo.
  class Servo
 
    Klass = Phidgets::FFI::CPhidgetServo
    include Phidgets::Common
    
	# Collection of servo motors
	# @return [ServoServos] 
    attr_reader :servos
	
	attr_reader :attributes
		
	# The attributes of a PhidgetServo
    def attributes
      super.merge({
        :servos => servos.size,
      })
    end

    # Sets a position change handler callback function. This is called when a the servo position has changed.
    #
    # @param [String] obj Object to pass to the callback function. This is optional.
    # @param [Proc] Block When the callback is executed, the device and object are yielded to this block.
    # @example
    #     servo.on_position_change do |motor, position, obj|
    #       puts "Moving servo #{motor.index} to #{position}"
    #     end
    # As this runs in it's own thread, be sure that all errors are properly handled or the thread will halt and not fire any more.
    # @return [Boolean] returns true or raises an error
      def on_position_change(obj=nil, &block)
      @on_position_change_obj = obj
      @on_position_change = Proc.new { |device, obj_ptr, index, position|
        yield self, @servos[index], position, object_for(obj_ptr)
      }
      Klass.set_OnPositionChange_Handler(@handle, @on_position_change, pointer_for(obj))
    end
	
  # This class represents a servo motor for a PhidgetServo. All the properties of an servo motor are stored and modified in this class.
  class ServoServos
    Klass = Phidgets::FFI::CPhidgetServo

	private
    def initialize(handle, index)
      @handle, @index = handle, index.to_i
    end

	public
	# Displays data for the servo motor.
    def inspect
      "#<#{self.class} @index=#{index}, @engaged=#{engaged}, @position_min=#{position_min}, @position_max=#{position_max}, @type=#{type}>"
	end

	# @return [Integer] returns the index of the servo motor, or raises an error.
	def index 
		@index
	end
	
	# @return [Boolean] returns the engaged state of a servo motor, or raises an error.
    def engaged
      ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getEngaged(@handle, @index, ptr)
      (ptr.get_int(0) == 0) ? false : true
    end

	# Sets the engaged state of a servo motor, or raises an error.
	# @param [Boolean] new_state new state
	# @return [Boolean] returns engaged state of a servo motor, or raises an error.
    def engaged=(new_state)
      tmp = new_state ? 1 : 0
      Klass.setEngaged(@handle, @index, tmp)
      new_state
    end
	
	# @return [Float] returns the largest position value that the servo motor will accept, or raises an error.
    def position_min
      ptr = ::FFI::MemoryPointer.new(:double)
      Klass.getPositionMin(@handle, @index, ptr)
      ptr.get_double(0)
    end

	# @return [Float] returns the largest position value that the servo motor will accept, or raises an error.
    def position_max
      ptr = ::FFI::MemoryPointer.new(:double)
      Klass.getPositionMax(@handle, @index, ptr)
      ptr.get_double(0)
    end
	
	# @return [Float] returns the position of the servo motor, or raises an error.
    def position
      ptr = ::FFI::MemoryPointer.new(:double)
      Klass.getPosition(@handle, @index, ptr)
      ptr.get_double(0)
    end
	
	# Sets the position of the servo motor, or raises an error.
	# @param [Float] new_position new position
	# @return [Float] returns the position of the servo motor, or raises an error.
    def position=(new_position)
      Klass.setPosition(@handle, @index, new_position.to_f)
      new_position
    end
	
	# @return [Phidgets::FFI::ServoType] returns the servo type of the servo motor, or raises an error.
	def type
      ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getServoType(@handle, @index, ptr)
      Phidgets::FFI::ServoType[ptr.get_int(0)]
    end

	# Sets the servo type of the servo motor, or raises an error. This determines how degrees are calculated from PCM pulses, and sets min and max angles.
	# @param [Phidgets::FFI::ServoType] new_type new type
	# @return [Phidgets::FFI:ServoType] returns the servo type of the servo motor, or raises an error.
    def type=(servo_type=:default)
      ptr = ::FFI::MemoryPointer.new(:int)
      Klass.setServoType(@handle, @index, Phidgets::FFI::ServoType[servo_type])
      servo_type
    end

	# Sets custom servo parameters for using a servo not in the predefined list. Pulse widths are specified in microseconds.
	# @param [Float] new_minimum_pulse_width new minimum pulse width
	# @param [Float] new_maximum_pulse_width new maximum pulse width
	# @param [Float] new_degrees new degrees
	# @return [Boolean] returns true if the servo parameters are successfully set, or raises an error.
    def set_servo_parameters(min_pcm, max_pcm, degrees)
      Klass.setServoParameters(@handle, @index, min_pcm.to_f, max_pcm.to_f, degrees.to_f)
      true
    end
	
  end #ServoServos
  
	private
    
	def load_device_attributes
	  load_servos
	end

    def load_servos
	  ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getMotorCount(@handle, ptr)
      @servos = []
      ptr.get_int(0).times do |i|
        @servos << ServoServos.new(@handle, i)
      end

    end
	
	def remove_specific_event_handlers
	   Klass.set_OnPositionChange_Handler(@handle, nil, nil)
	end
  end

end
