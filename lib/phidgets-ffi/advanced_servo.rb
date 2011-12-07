module Phidgets

  # This class represents a PhidgetAdvancedServo.
  class AdvancedServo
 
    Klass = Phidgets::FFI::CPhidgetAdvancedServo
    include Phidgets::Common
    
	# Collection of servo motors
	# @return [AdvancedServoServos] 
    attr_reader :advanced_servos
	
	attr_reader :attributes
		
	# The attributes of a PhidgetAdvancedServo
    def attributes
      super.merge({
        :advanced_servos => advanced_servos.size,
      })
    end

    # Sets a velocity change handler callback function. This is called when the velocity of a servo changes.
    #
    # @param [String] obj Object to pass to the callback function. This is optional.
    # @param [Proc] Block When the callback is executed, the device and object are yielded to this block.
    # @example
    #     adv.on_velocity_change do |device, servo, velocity, obj|
    #       puts "Servo #{servo.index}'s velocity has changed to #{velocity}"
    #     end
    # As this runs in it's own thread, be sure that all errors are properly handled or the thread will halt and not fire any more.
    # @return [Boolean] returns true or raises an error
    def on_velocity_change(obj=nil, &block)
	
      @on_velocity_change_obj = obj
      @on_velocity_change = Proc.new { |device, obj_ptr, index, velocity|
	    yield self, @advanced_servos[index], velocity, object_for(obj_ptr)
	}
      Klass.set_OnVelocityChange_Handler(@handle, @on_velocity_change, pointer_for(obj))
    end
	
    # Sets a position change handler callback function. This is called when the servo position has changed. 
    #
    # @param [String] obj Object to pass to the callback function. This is optional.
    # @param [Proc] Block When the callback is executed, the device and object are yielded to this block.
    # @example
    #     adv.on_position_change do |device, servo, position, obj|
    #       puts "Servo #{servo.index}'s position has changed to #{position}"
    #     end
    # As this runs in it's own thread, be sure that all errors are properly handled or the thread will halt and not fire any more.
    # @return [Boolean] returns true or raises an error
    def on_position_change(obj=nil, &block)
	
      @on_position_change_obj = obj
      @on_position_change = Proc.new { |device, obj_ptr, index, position|
	    yield self, @advanced_servos[index], position, object_for(obj_ptr)
	}
      Klass.set_OnPositionChange_Handler(@handle, @on_position_change, pointer_for(obj))
    end
	
    # Sets a current change handler handler callback function. This is called when the current consumed by a motor changes.
    #
    # @param [String] obj Object to pass to the callback function. This is optional.
    # @param [Proc] Block When the callback is executed, the device and object are yielded to this block.
    # @example
    #     adv.on_current_change do |device, servo, current, obj|
    #       puts "Servo #{servo.index}'s current has changed to #{current}"
    #     end
    # As this runs in it's own thread, be sure that all errors are properly handled or the thread will halt and not fire any more.
    # @return [Boolean] returns true or raises an error
    def on_current_change(obj=nil, &block)
	
      @on_current_change_obj = obj
      @on_current_change = Proc.new { |device, obj_ptr, index, current|
	    yield self, @advanced_servos[index], current, object_for(obj_ptr)
	}
      Klass.set_OnCurrentChange_Handler(@handle, @on_current_change, pointer_for(obj))
    end

	 
  # This class represents a servo motor for a PhidgetAdvancedServo. All the properties of an servo motor are stored and modified in this class.
  class AdvancedServoServos
    Klass = Phidgets::FFI::CPhidgetAdvancedServo

	private
    def initialize(handle, index)
      @handle, @index = handle, index.to_i
    end

	public
	# Displays data for the servo motor.
    def inspect
      "#<#{self.class} @index=#{index}, @acceleration=#{acceleration}, @acceleration_min=#{acceleration_min}, @acceleration_max=#{acceleration_max}, @current=#{current}, @engaged=#{engaged}, @position=#{position}, @position_max=#{position_max}, @position_min=#{position_min}, @speed_ramping=#{speed_ramping}, @stopped=#{stopped}, @type=#{type}, @velocity=#{velocity}, @velocity_limit=#{velocity_limit}, @velocity_min=#{velocity_min}, @velocity_max=#{velocity_max}>"
	end

	# @return [Integer] returns the index of the servo motor, or raises an error.
	def index 
		@index
	end
	
	# @return [Float] returns the acceleration of a servo, in degrees/second, or raises an error.
    def acceleration
      ptr = ::FFI::MemoryPointer.new(:double)
      Klass.getAcceleration(@handle, @index, ptr)
      ptr.get_double(0)
    end

	# Sets the acceleration of a servo, in degrees/second, or raises an error.
	# @param [Integer] new_acceleration new acceleration
	# @return [Float] returns acceleration of a servo, in degrees/second, or raises an error.    
	def acceleration=(new_acceleration)
      Klass.setAcceleration(@handle, @index, new_acceleration.to_f)
	  new_acceleration
    end	  

	# @return [Float] returns the largest acceleration value that the servo motor will accept, or raises an error.
    def acceleration_max
      ptr = ::FFI::MemoryPointer.new(:double)
      Klass.getAccelerationMax(@handle, @index, ptr)
      ptr.get_double(0)
    end

	# @return [Float] returns the smallest acceleration value that the servo motor will accept, or raises an error.
    def acceleration_min
      ptr = ::FFI::MemoryPointer.new(:double)
      Klass.getAccelerationMin(@handle, @index, ptr)
      ptr.get_double(0)
    end

	# @return [Float] returns the current consumption of a servo motor, in Amps, or raises an error.
    def current
      ptr = ::FFI::MemoryPointer.new(:double)
      Klass.getCurrent(@handle, @index, ptr)
      ptr.get_double(0)
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
	
	# @return [Float] returns the position of the servo motor, in degrees, or raises an error.
    def position
      ptr = ::FFI::MemoryPointer.new(:double)
      Klass.getPosition(@handle, @index, ptr)
      ptr.get_double(0)
    end
	
	# Sets the position of the servo motor, in degrees, or raises an error.
	# @param [Float] new_position new position
	# @return [Float] returns the position of the servo motor, in degrees, or raises an error.
    def position=(new_position)
      Klass.setPosition(@handle, @index, new_position.to_f)
      new_position
    end
	
	# @return [Float] returns the largest position value that the servo motor will accept, or raises an error.
    def position_max
      ptr = ::FFI::MemoryPointer.new(:double)
      Klass.getPositionMax(@handle, @index, ptr)
      ptr.get_double(0)
    end
	
	# Sets the largest position value that the servo motor will accept, or raises an error.
	# @param [Float] new_position_max new maximum position
	# @return [Float] returns the largest position value that the servo motor will accept, or raises an error.
    def position_max=(new_position_max)
      Klass.setPositionMax(@handle, @index, new_position_max.to_f)
      new_position_max
    end
	
	# @return [Float] returns the smallest position value that the servo motor will accept, or raises an error.
    def position_min
      ptr = ::FFI::MemoryPointer.new(:double)
      Klass.getPositionMin(@handle, @index, ptr)
      ptr.get_double(0)
    end

	# Sets the smallest position value that the servo motor will accept, or raises an error.
	# @param [Float] new_position_min new minimum position
	# @return [Float] returns the smallest position value that the servo motor will accept, or raises an error.
    def position_min=(new_position_min)
      Klass.setPositionMin(@handle, @index, new_position_min.to_f)
      new_position_min
    end
	
	# @return [Boolean] returns the speed ramping state of the servo motor, or raises an error.
    def speed_ramping
      ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getSpeedRampingOn(@handle, @index, ptr)
      (ptr.get_int(0) == 0) ? false : true
    end
	
	# Sets the speed ramping state that the servo motor will accept, or raises an error.
	# @param [Boolean] new_state new state
	# @return [Boolean] returns the speed ramping state that the servo motor will accept, or raises an error.
	def speed_ramping=(new_state)
      tmp = new_state ? 1 : 0
      Klass.setSpeedRampingOn(@handle, @index, tmp)
      new_state
    end
	
	# @return [Boolean] returns the stopped state of the servo motor, or raises an error.
    def stopped
      ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getStopped(@handle, @index, ptr)
      (ptr.get_int(0) == 0) ? false : true
    end
	
	# @return [Phidgets::FFI::AdvancedServoType] returns the servo type of the servo motor, or raises an error.
	def type
      ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getServoType(@handle, @index, ptr)
      Phidgets::FFI::ServoType[ptr.get_int(0)]
    end

	# Sets the servo type of the servo motor, or raises an error. This determines how degrees are calculated from PCM pulses, and sets min and max angles. The default type is :default. 
	# @param [Phidgets::FFI::AdvancedServoType] new_type new type
	# @return [Phidgets::FFI::AdvancedServoType] returns the servo type of the servo motor, or raises an error.
    def type=(new_type=:default)
      ptr = ::FFI::MemoryPointer.new(:int)
      Klass.setServoType(@handle, @index, Phidgets::FFI::AdvancedServoType[new_type])
      new_type
    end
	
	# @return [Float] returns the current velocity of the servo motor, or raises an error.
    def velocity
      ptr = ::FFI::MemoryPointer.new(:double)
      Klass.getVelocity(@handle, @index, ptr)
      ptr.get_double(0)
    end

	# @return [Float] returns the velocity limit of the servo motor, or raises an error.
    def velocity_limit
      ptr = ::FFI::MemoryPointer.new(:double)
      Klass.getVelocityLimit(@handle, @index, ptr)
      ptr.get_double(0)
    end

	# Sets the velocity limit of the servo motor, or raises an error.
	# @param [Float] new_velocity_limit new velocity limit
	# @return [Float] returns the velocity limit of the servo motor, or raises an error.
    def velocity_limit=(new_velocity_limit)
      Klass.setVelocityLimit(@handle, @index, new_velocity_limit.to_f)
      new_velocity_limit
    end

	# @return [Float] returns the largest velocity value that the servo motor will accept, or raises an error.
    def velocity_max
      ptr = ::FFI::MemoryPointer.new(:double)
      Klass.getVelocityMax(@handle, @index, ptr)
      ptr.get_double(0)
    end
	
	# @return [Float] returns the smallest velocity value that the servo motor will accept, or raises an error.
    def velocity_min
      ptr = ::FFI::MemoryPointer.new(:double)
      Klass.getVelocityMin(@handle, @index, ptr)
      ptr.get_double(0)
    end
	
	# Sets custom servo parameters for using a servo not in the predefined list. Pulse widths are specified in microseconds, velocity in degrees/second.
	# @return [Boolean] returns the true if the servo parameters has successfully been set, or raises an error.
	def set_servo_parameters(min_us, max_us, degrees, velocity_max)
	  Klass.setServoParameters(@handle, @index, min_us, max_us, degrees, velocity_max)
	  true
	end
	
  end #AdvancedServoServos
  
	private
    
	def load_device_attributes
	  load_advanced_servos
	end

    def load_advanced_servos
	  ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getMotorCount(@handle, ptr)
      @advanced_servos = []
      ptr.get_int(0).times do |i|
        @advanced_servos << AdvancedServoServos.new(@handle, i)
      end

    end
	
	def remove_specific_event_handlers
	   Klass.set_OnPositionChange_Handler(@handle, nil, nil)
	   Klass.set_OnVelocityChange_Handler(@handle, nil, nil)
	   Klass.set_OnCurrentChange_Handler(@handle, nil, nil)
	end
  end
	
end