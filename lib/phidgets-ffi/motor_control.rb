module Phidgets

  # This class represents a PhidgetMotorControl.
  class MotorControl
 
    Klass = Phidgets::FFI::CPhidgetMotorControl
    include Phidgets::Common
    
	# Collection of motors
	# @return [MotorControlMotors] 
    attr_reader :motors

	# Collection of encoders
	# @return [MotorControlEncoders] 
    attr_reader :encoders

	# Collection of digital inputs
	# @return [MotorControlDigitalInputs] 
    attr_reader :inputs

	# Collection of analog sensors
	# @return [MotorControlAnalogSensors] 
    attr_reader :sensors
	
	attr_reader :attributes
		
	# The attributes of a PhidgetMotorControl
    def attributes
      super.merge({
		:motors => motors.size,
		:encoders => encoders.size,
		:inputs => inputs.size,
		:sensors => sensors.size,
		:ratiometric => ratiometric
      })
    end

    # Sets a velocity change handler callback function. This is called when the velocity of a motor changes.
    #
    # @param [String] obj Object to pass to the callback function. This is optional.
    # @param [Proc] Block When the callback is executed, the device and object are yielded to this block.
    # @example
    #     mc.on_velocity_change do |device, motor, velocity|
    #       puts "Motor #{motor.index}'s velocity changed to #{velocity}"
    #     end
    # As this runs in it's own thread, be sure that all errors are properly handled or the thread will halt and not fire any more.
    # @return [Boolean] returns true or raises an error
    def on_velocity_change(obj=nil, &block)
	
      @on_velocity_change_obj = obj
      @on_velocity_change = Proc.new { |device, obj_ptr, motor, velocity|
	    yield self, @motors[motor], velocity, object_for(obj_ptr)

	}
      Klass.set_OnVelocityChange_Handler(@handle, @on_velocity_change, pointer_for(obj))
    end

    # Sets a current change handler callback function. This is called when the current consumed by a motor changes.
    #
    # @param [String] obj Object to pass to the callback function. This is optional.
    # @param [Proc] Block When the callback is executed, the device and object are yielded to this block.
    # @example
    #     mc.on_current_change do |device, motor, current|
    #       puts "Motor #{motor.index}'s current changed to #{current}"
    #     end
    # As this runs in it's own thread, be sure that all errors are properly handled or the thread will halt and not fire any more.
    # @return [Boolean] returns true or raises an error
    def on_current_change(obj=nil, &block)
	
      @on_current_change_obj = obj
      @on_current_change = Proc.new { |device, obj_ptr, motor, current|
	    yield self, @motors[motor], current, object_for(obj_ptr)

	}
      Klass.set_OnCurrentChange_Handler(@handle, @on_current_change, pointer_for(obj))
    end
	
    # Sets a current update handler callback function. This is called when the current consumed by a motor changes.
    #
    # @param [String] obj Object to pass to the callback function. This is optional.
    # @param [Proc] Block When the callback is executed, the device and object are yielded to this block.
    # @example
    #     mc.on_current_update do |device, motor, current|
    #       puts "Motor #{motor.index}'s current is #{current}"
    #     end
    # As this runs in it's own thread, be sure that all errors are properly handled or the thread will halt and not fire any more.
    # @return [Boolean] returns true or raises an error
    def on_current_update(obj=nil, &block)
	
      @on_current_update_obj = obj
      @on_current_update = Proc.new { |device, obj_ptr, motor, current|
	    yield self, @motors[motor], current, object_for(obj_ptr)

	}
      Klass.set_OnCurrentChange_Handler(@handle, @on_current_update, pointer_for(obj))
    end
	
    # Sets an input change handler callback function. This is called when a digital input on the PhidgetMotorControl board has changed.
    #
    # @param [String] obj Object to pass to the callback function. This is optional.
    # @param [Proc] Block When the callback is executed, the device and object are yielded to this block.
    # @example
    #     mc.on_input_change do |device, input, state, obj|
    #       puts "Digital Input  #{input.index}, changed to #{state}"
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
	
    # Sets a Back EMF update handler callback function. This is called at a steady rate of 16ms, when BackEMF sensing is enabled.
    #
    # @param [String] obj Object to pass to the callback function. This is optional.
    # @param [Proc] Block When the callback is executed, the device and object are yielded to this block.
    # @example
    #     mc.on_back_emf_update do |device, motor, voltage|
    #       puts "Motor #{motor.index}'s back EMF is #{voltage}"
    #     end
    # As this runs in it's own thread, be sure that all errors are properly handled or the thread will halt and not fire any more.
    # @return [Boolean] returns true or raises an error
    def on_back_emf_update(obj=nil, &block)
      @on_back_emf_update_obj = obj
      @on_back_emf_update = Proc.new { |device, obj_ptr, motor, voltage|
        yield self, @motors[motor], voltage, object_for(obj_ptr)
      }
      Klass.set_OnBackEMFUpdate_Handler(@handle, @on_back_emf_update, pointer_for(obj))
    end
	
    # Sets a position change handler callback function. This event provides data about how many ticks have occured, and how much time has passed since the last position change event, but does not contain an absolute position. This be be obtained from {Phidgets::MotorControl::MotorControlEncoders#position}
    #
    # @param [String] obj Object to pass to the callback function. This is optional.
    # @param [Proc] Block When the callback is executed, the device and object are yielded to this block.
    # @example
    #     mc.on_position_change do |device, encoder, time, position|
    #       puts "Encoder #{encoder.index}'s position changed to #{position} in #{time}"
    #     end
    # As this runs in it's own thread, be sure that all errors are properly handled or the thread will halt and not fire any more.
    # @return [Boolean] returns true or raises an error
    def on_position_change(obj=nil, &block)
	
      @on_position_change_obj = obj
      @on_position_change = Proc.new { |device, obj_ptr, encoder, time, position|
	    yield self, @encoders[encoder], time, position, object_for(obj_ptr)

	}
      Klass.set_OnEncoderPositionChange_Handler(@handle, @on_position_change, pointer_for(obj))
    end

    # Sets a position update handler callback function. This event provides data about how many ticks have occured since the last update event. It is called at a steady rate of 8ms.
    #
    # @param [String] obj Object to pass to the callback function. This is optional.
    # @param [Proc] Block When the callback is executed, the device and object are yielded to this block.
    # @example
    #     mc.on_position_update do |device, encoder, position|
    #       puts "Encoder #{encoder.index}'s position is #{position}"
    #     end
    # As this runs in it's own thread, be sure that all errors are properly handled or the thread will halt and not fire any more.
    # @return [Boolean] returns true or raises an error
    def on_position_update(obj=nil, &block)
	
      @on_position_update_obj = obj
      @on_position_update = Proc.new { |device, obj_ptr, encoder, position|
	    yield self, @encoders[encoder], position, object_for(obj_ptr)

	}
      Klass.set_OnEncoderPositionUpdate_Handler(@handle, @on_position_update, pointer_for(obj))
    end	

    # Sets a sensor update handler callback function. This is called at a steady rate of 8ms.
    #
    # @param [String] obj Object to pass to the callback function. This is optional.
    # @param [Proc] Block When the callback is executed, the device and object are yielded to this block.
    # @example
    #     mc.on_sensor_update do |device, sensor, value|
    #       puts "Analog Sensor #{sensor.index}'s value is #{value}"
    #     end
    # As this runs in it's own thread, be sure that all errors are properly handled or the thread will halt and not fire any more.
    # @return [Boolean] returns true or raises an error
    def on_sensor_update(obj=nil, &block)
      @on_sensor_update_obj = obj
      @on_sensor_update = Proc.new { |device, obj_ptr, index, value|
        yield self, @sensors[index], value, object_for(obj_ptr)
      }
      Klass.set_OnSensorUpdate_Handler(@handle, @on_sensor_update, pointer_for(obj))
    end
	
	# Returns the ratiometric state of the board
    #
    # @return [Boolean] returns the ratiometric state or raises an error
    def ratiometric
      ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getRatiometric(@handle, ptr)
      (ptr.get_int(0) == 0) ? false : true
    end
    alias_method :ratiometric?, :ratiometric

    # Sets the ratiometric state of the board.
    # @param [Boolean] new_state new ratiometric state
    # @return [Boolean] returns the ratiometric state or raises an error
    def ratiometric=(new_state)
      tmp = new_state ? 1 : 0
      Klass.setRatiometric(@handle, tmp)
      new_state
    end
	
  # This class represents a motor for a PhidgetMotorControl. All the properties of a motor are stored and modified in this class.
  class MotorControlMotors
    Klass = Phidgets::FFI::CPhidgetMotorControl

	private
    def initialize(handle, index)
      @handle, @index = handle, index.to_i
    end

	public
	# Displays data for the motor.
    def inspect
      "#<#{self.class} @index=#{index}, @acceleration=#{acceleration}, @acceleration_min=#{acceleration_min}, @acceleration_max=#{acceleration_max}, @velocity=#{velocity}>"
	end

	# @return [Integer] returns the index of the  motor, or raises an error.
	def index 
		@index
	end
	
	# @return [Float] returns the acceleration of a motor, or raises an error.
    def acceleration
      ptr = ::FFI::MemoryPointer.new(:double)
      Klass.getAcceleration(@handle, @index, ptr)
      ptr.get_double(0)
    end

	# Sets the acceleration of a motor, or raises an error.
	# @param [Integer] new_acceleration new acceleration
	# @return [Float] returns acceleration of a motor, or raises an error.    
	def acceleration=(new_acceleration)
      Klass.setAcceleration(@handle, @index, new_acceleration.to_f)
	  new_acceleration
    end	  

	# @return [Float] returns the largest acceleration value that the motor will accept, or raises an error.
    def acceleration_max
      ptr = ::FFI::MemoryPointer.new(:double)
      Klass.getAccelerationMax(@handle, @index, ptr)
      ptr.get_double(0)
    end

	# @return [Float] returns the smallest acceleration value that the motor will accept, or raises an error.
    def acceleration_min
      ptr = ::FFI::MemoryPointer.new(:double)
      Klass.getAccelerationMin(@handle, @index, ptr)
      ptr.get_double(0)
    end

	# @return [Float] returns the current consumption of a motor, in Amps, or raises an error.
    def current
      ptr = ::FFI::MemoryPointer.new(:double)
      Klass.getCurrent(@handle, @index, ptr)
      ptr.get_double(0)
    end
	
	# Sets the back EMF sensing state of a motor, or raises an error.
	# @param [Boolean] new_back_emf_sensing new back EMf sensing state
	# @return [Boolean] sets the back EMF sensing state of a motor, or raises an error.
	def back_emf_sensing=(new_back_emf_sensing)
      tmp = new_back_emf_sensing ? 1 : 0
      Klass.setBackEMFSensingState(@handle, @index, tmp)
      new_back_emf_sensing
    end

	# @return [Boolean] returns the back EMF sensing state of a motor, or raises an error.
    def back_emf_sensing
      ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getBackEMFSensingState(@handle, @index, ptr)
      (ptr.get_int(0) == 0) ? false : true
    end
	
	# @return [Float] returns the back EMF value of a motor, in volts, or raises an error.
    def back_emf
      ptr = ::FFI::MemoryPointer.new(:double)
      Klass.getBackEMF(@handle, @index, ptr)
      ptr.get_double(0)
    end

	# @return [Float] returns the velocity of a motor, or raises an error.
    def velocity
      ptr = ::FFI::MemoryPointer.new(:double)
      Klass.getVelocity(@handle, @index, ptr)
      ptr.get_double(0)
    end

	# Sets the velocity of a motor, or raises an error.
	# @param [Integer] new_velocity new velocity
	# @return [Float] returns the velocity of a motor, or raises an error.    
	def velocity=(new_velocity)
      Klass.setVelocity(@handle, @index, new_velocity.to_f)
	  new_velocity
    end	 	
	
	# @return [Float] returns the braking value of a motor, or raises an error.
    def braking
      ptr = ::FFI::MemoryPointer.new(:double)
      Klass.getBraking(@handle, @index, ptr)
      ptr.get_double(0)
    end

	# Sets the braking value of a motor, or raises an error. The value can be between 0-100%
	# @param [Integer] new_braking new braking
	# @return [Float] returns the braking value of a motor, or raises an error.    
	def braking=(new_braking)
      Klass.setBraking(@handle, @index, new_braking.to_f)
	  new_braking
    end	 	
	
  end #MotorControlMotors

 # This class represents an analog sensor for a PhidgetMotorControl. All the properties of an analog sensor are stored and modified in this class.
  class MotorControlAnalogSensors
    Klass = Phidgets::FFI::CPhidgetMotorControl

	private
    def initialize(handle, index)
      @handle, @index = handle, index.to_i
    end

	public
	
	# Displays data for the analog sensor
    def inspect
      "#<#{self.class} @value=#{value}, @raw_value=#{raw_value}>"
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
	
  end #MotorControlAnalogSensors

 # This class represents a digital input for a PhidgetMotorControl. All the properties of an digital input are stored and modified in this class.
  class MotorControlDigitalInputs
    Klass = Phidgets::FFI::CPhidgetMotorControl

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
	
  end #MotorControlDigitalInputs

 # This class represents an encoder for a PhidgetMotorControl. All the properties of an encoder are stored and modified in this class.
  class MotorControlEncoders
    Klass = Phidgets::FFI::CPhidgetMotorControl

	private
    def initialize(handle, index)
      @handle, @index = handle, index.to_i
    end

	public
	
	# Displays data for the encoder
    def inspect
      "#<#{self.class} @index=#{index}, @position=#{position}>"
    end

	# @return [Integer] returns index of the digital input, or raises an error.
	def index 
		@index
	end
	
	# @return [Integer] returns the position of an encoder, or raises an error.
    def position
      ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getEncoderPosition(@handle, @index, ptr)
      ptr.get_int(0)
    end
	
	# Sets the position of an encoder, or raises an error.
	# @param [Integer] new_position new position
	# @return [Integer] returns the position of an encoder, or raises an error.
    def position=(new_position)
      Klass.setEncoderPosition(@handle, @index, new_position.to_i)
      new_position
    end	
	
  end #MotorControlEncoders

	private
    
	def load_device_attributes
		load_analog_sensors
		load_inputs
		load_encoders
		load_motors
	end

    def load_analog_sensors
	  ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getSensorCount(@handle, ptr)
      @sensors = []
      ptr.get_int(0).times do |i|
        @sensors << MotorControlAnalogSensors.new(@handle, i)
      end
    end

    def load_inputs
	  ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getInputCount(@handle, ptr)
      @inputs = []
      ptr.get_int(0).times do |i|
        @inputs << MotorControlDigitalInputs.new(@handle, i)
      end
    end

    def load_encoders
	  ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getEncoderCount(@handle, ptr)
      @encoders = []
      ptr.get_int(0).times do |i|
        @encoders << MotorControlEncoders.new(@handle, i)
      end
    end

    def load_motors
	  ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getMotorCount(@handle, ptr)
      @motors = []
      ptr.get_int(0).times do |i|
        @motors << MotorControlMotors.new(@handle, i)
      end
    end

	def remove_specific_event_handlers
	   Klass.set_OnVelocityChange_Handler(@handle, nil, nil)
	   Klass.set_OnCurrentChange_Handler(@handle, nil, nil)
	   Klass.set_OnInputChange_Handler(@handle, nil, nil)
	   Klass.set_OnEncoderPositionChange_Handler(@handle, nil, nil)
	   Klass.set_OnEncoderPositionUpdate_Handler(@handle, nil, nil)
	   Klass.set_OnBackEMFUpdate_Handler(@handle, nil, nil)	 
	   Klass.set_OnSensorUpdate_Handler(@handle, nil, nil)
	   Klass.set_OnCurrentUpdate_Handler(@handle, nil, nil)		   
	end
  end

end