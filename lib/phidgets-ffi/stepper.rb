module Phidgets

  # This class represents a PhidgetStepper.
  class Stepper
 
    Klass = Phidgets::FFI::CPhidgetStepper
    include Phidgets::Common
    
	# Collection of digital inputs
	# @return [StepperDigitalInputs] 
    attr_reader :inputs

	# Collection of stepper motors
	# @return [StepperSteppers] 
    attr_reader :steppers
	
	attr_reader :attributes
    
	# The attributes of a PhidgetStepper
	def attributes
      super.merge({
        :inputs => inputs.size,
		:steppers => steppers.size,
      })
    end

    # Sets an input change handler callback function. This is called when a digital input on the PhidgetStepper board has changed.
    #
    # @param [String] obj Object to pass to the callback function. This is optional.
    # @param [Proc] Block When the callback is executed, the device and object are yielded to this block.
    # @example
    #     st.on_input_change do |device, input, state, obj|
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
	
    # Sets a velocity change handler callback function. This is called when a stepper velocity changes.
    #
    # @param [String] obj Object to pass to the callback function. This is optional.
    # @param [Proc] Block When the callback is executed, the device and object are yielded to this block.
    # @example
    #     st.on_velocity_change do |device, stepper, velocity, obj|
    #       puts "Stepper #{stepper.index}'s velocity has changed to #{velocity}"
    #     end
    # As this runs in it's own thread, be sure that all errors are properly handled or the thread will halt and not fire any more.
    # @return [Boolean] returns true or raises an error
    def on_velocity_change(obj=nil, &block)
      @on_velocity_change_obj = obj
      @on_velocity_change = Proc.new { |device, obj_ptr, index, velocity|
        yield self, @steppers[index], velocity, object_for(obj_ptr)
      }
      Klass.set_OnVelocityChange_Handler(@handle, @on_velocity_change, pointer_for(obj))
    end
	
    # Sets a position change handler callback function. This is called when the stepper position changes.
    #
    # @param [String] obj Object to pass to the callback function. This is optional.
    # @param [Proc] Block When the callback is executed, the device and object are yielded to this block.
    # @example
    #     st.on_position_change do |device, stepper, position, obj|
    #       puts "Stepper #{stepper.index}'s position has changed to #{position}"
    #     end
    # As this runs in it's own thread, be sure that all errors are properly handled or the thread will halt and not fire any more.
    # @return [Boolean] returns true or raises an error
    def on_position_change(obj=nil, &block)
      @on_position_change_obj = obj
      @on_position_change = Proc.new { |device, obj_ptr, index, position|
        yield self, @steppers[index], position, object_for(obj_ptr)
      }
      Klass.set_OnPositionChange_Handler(@handle, @on_position_change, pointer_for(obj))
    end
 
    # Sets a current change handler callback function. This is called when current consumption of a stepper changes. Not all PhidgetSteppers support current sense.
    #
    # @param [String] obj Object to pass to the callback function. This is optional.
    # @param [Proc] Block When the callback is executed, the device and object are yielded to this block.
    # @example
    #     st.on_current_change do |device, stepper, current, obj|
    #       puts "Stepper #{stepper.index}'s current has changed to #{current}"
    #     end
    # As this runs in it's own thread, be sure that all errors are properly handled or the thread will halt and not fire any more.
    # @return [Boolean] returns true or raises an error
    def on_current_change(obj=nil, &block)
      @on_current_change_obj = obj
      @on_current_change = Proc.new { |device, obj_ptr, index, current|
        yield self, @steppers[index], current, object_for(obj_ptr)
      }
      Klass.set_OnCurrentChange_Handler(@handle, @on_current_change, pointer_for(obj))
    end
	
  # This class represents a digital input for a PhidgetStepper. All the properties of an digital input are stored and modified in this class.
  class StepperDigitalInputs
    Klass = Phidgets::FFI::CPhidgetStepper

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
  end #StepperDigitalInputs
    
  # This class represents a stepper motor of a PhidgetStepper. All the properties of a stepper motor are stored and modified in this class.
  class StepperSteppers
    Klass = Phidgets::FFI::CPhidgetStepper

	private
    def initialize(handle, index)
      @handle, @index = handle, index.to_i
    end
	
	public
	
	# Displays data for the stepper
    def inspect
      "#<#{self.class} @index=#{index}, @acceleration_min=#{acceleration_min}, @acceleration_max=#{acceleration_max}, @current_min=#{current_min}, @current_max=#{current_max}, @engaged=#{engaged}, @position_min=#{position_min}, @position_max=#{position_max}, @velocity_min=#{velocity_min}, @velocity_max=#{velocity_max}>"
	 
    end
	
	# @return [Integer] returns index of the stepper, or raises an error.
	def index 
		@index
	end
	
	# @return [Float] returns the acceleration of a stepper, in (micro)steps per second squared, or raises an error.
    def acceleration
      ptr = ::FFI::MemoryPointer.new(:double)
      Klass.getAcceleration(@handle, @index, ptr)
      ptr.get_double(0)
    end

	# Sets the acceleration of a stepper, in (micro)steps per second squared, or raises an error.
	# @param [Integer] new_acceleration new acceleration
	# @return [Float] returns acceleration of a servo, in degrees/second, or raises an error.    
	def acceleration=(new_acceleration)
      Klass.setAcceleration(@handle, @index, new_acceleration.to_f)
	  new_acceleration
    end	  

	# @return [Float] returns the largest acceleration value that the stepper will accept, or raises an error.
    def acceleration_max
      ptr = ::FFI::MemoryPointer.new(:double)
      Klass.getAccelerationMax(@handle, @index, ptr)
      ptr.get_double(0)
    end

	# @return [Float] returns the smallest acceleration value that the stepper will accept, or raises an error.
    def acceleration_min
      ptr = ::FFI::MemoryPointer.new(:double)
      Klass.getAccelerationMin(@handle, @index, ptr)
      ptr.get_double(0)
    end

	# @return [Float] returns the stepper's current usage, in Amps, or raises an error.
    def current
      ptr = ::FFI::MemoryPointer.new(:double)
      Klass.getCurrent(@handle, @index, ptr)
      ptr.get_double(0)
    end

	# @return [Float] returns the stepper's current usage limit, in Amps, or raises an error.
    def current_limit
      ptr = ::FFI::MemoryPointer.new(:double)
      Klass.getCurrentLimit(@handle, @index, ptr)
      ptr.get_double(0)
    end

	# Sets the stepper's current usage limit, in Amps, or raises an error.
	# @param [Integer] new_current_limit new current limit
	# @return [Float] returns current limit, in Amps, or raises an error.    
	def current_limit=(new_current_limit)
      Klass.setCurrentLimit(@handle, @index, new_current_limit.to_f)
	  new_current_limit
    end	  
	
	# @return [Float] returns the largest current value that the stepper will accept, or raises an error.
    def current_max
      ptr = ::FFI::MemoryPointer.new(:double)
      Klass.getCurrentMax(@handle, @index, ptr)
      ptr.get_double(0)
    end

	# @return [Float] returns the smallest acceleration value that the stepper will accept, or raises an error.
    def current_min
      ptr = ::FFI::MemoryPointer.new(:double)
      Klass.getCurrentMin(@handle, @index, ptr)
      ptr.get_double(0)
    end

	# @return [Integer] returns the stepper's current position, in (micro)steps, or raises an error.
    def current_position
      ptr = ::FFI::MemoryPointer.new(:long_long)
      Klass.getCurrentPosition(@handle, @index, ptr)
      ptr.get_long_long(0)
    end

	# Sets the current position of a stepper, in (micro)steps, or raises an error.
	# @param [Integer] new_current_position new current position
	# @return [Integer] returns the current position of a stepper, in (micro)steps, or raises an error.    
	def current_position=(new_current_position)
      Klass.setCurrentPosition(@handle, @index, new_current_position.to_i)
	  new_current_position
    end	  	
	
    # Returns the engaged state of the stepper.
    #
    # @return [Boolean] returns the engaged state or raises an error
    def engaged
      ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getEngaged(@handle, @index, ptr)
      (ptr.get_int(0) == 0) ? false : true
    end

    # Sets the engaged state of the Phidget.
    # @param [Boolean] new_state new engaged state
    # @return [Boolean] returns the engaged state or raises an error
    def engaged=(new_state)
      tmp = new_state ? 1 : 0
      Klass.setEngaged(@handle, @index, tmp)
      new_state
    end

	# @return [Integer] returns the largest position value that the stepper will accept, or raises an error.
    def position_max
      ptr = ::FFI::MemoryPointer.new(:long_long)
      Klass.getPositionMax(@handle, @index, ptr)
      ptr.get_long_long(0)
    end

	# @return [Integer] returns the smallest acceleration value that the stepper will accept, or raises an error.
    def position_min
      ptr = ::FFI::MemoryPointer.new(:long_long)
      Klass.getPositionMin(@handle, @index, ptr)
      ptr.get_long_long(0)
    end
	
	# @return [Boolean] returns the stopped state of a stepper, or raises an error.
    def stopped
      ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getStopped(@handle, @index, ptr)
      ptr.get_int(0)
    end
	
	# @return [Integer] returns the stepper's target position, in (micro)steps, in degrees/second, or raises an error.
    def target_position
      ptr = ::FFI::MemoryPointer.new(:long_long)
      Klass.getTargetPosition(@handle, @index, ptr)
      ptr.get_long_long(0)
    end

	# Sets the target position of a stepper, in (micro)steps, or raises an error.
	# @param [Integer] new_target_position new target position
	# @return [Integer] returns the target position of a stepper, in (micro)steps, or raises an error.    
	def target_position=(new_target_position)
      Klass.setTargetPosition(@handle, @index, new_target_position.to_i)
	  new_target_position
    end	  	

	# @return [Float] returns the stepper's current velocity, in (micro)steps per second, or raises an error.
    def velocity
      ptr = ::FFI::MemoryPointer.new(:double)
      Klass.getVelocity(@handle, @index, ptr)
      ptr.get_double(0)
    end	
	
	# @return [Float] returns the stepper's velocity limit, in (micro)steps per second, or raises an error.
    def velocity_limit
      ptr = ::FFI::MemoryPointer.new(:double)
      Klass.getVelocityLimit(@handle, @index, ptr)
      ptr.get_double(0)
    end

	# Sets the velocity limit of a stepper, in (micro)steps per second, or raises an error.
	# @param [Integer] new_velocity_limit new velocity limit
	# @return [Float] returns the velocity limit of a stepper, in (micro)steps per second, or raises an error.    
	def velocity_limit=(new_velocity_limit)
      Klass.setVelocityLimit(@handle, @index, new_velocity_limit.to_f)
	  new_velocity_limit
    end	  

	# @return [Float] returns the largest velocity value that the stepper will accept, or raises an error.
    def velocity_max
      ptr = ::FFI::MemoryPointer.new(:double)
      Klass.getVelocityMax(@handle, @index, ptr)
      ptr.get_double(0)
    end

	# @return [Float] returns the smallest velocity value that the stepper will accept, or raises an error.
    def velocity_min
      ptr = ::FFI::MemoryPointer.new(:double)
      Klass.getVelocityMin(@handle, @index, ptr)
      ptr.get_double(0)
    end
	
  end #StepperSteppers
    
	
	private
    
	def load_device_attributes
		load_inputs
		load_stepper_steppers
	end
	
    def load_inputs
      ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getInputCount(@handle, ptr)

      @inputs = []
      ptr.get_int(0).times do |i|
        @inputs << StepperDigitalInputs.new(@handle, i)
      end
    end
	
	def load_stepper_steppers
      ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getMotorCount(@handle, ptr)

      @steppers = []
      ptr.get_int(0).times do |i|
        @steppers << StepperSteppers.new(@handle, i)
      end
    end
	
	def remove_specific_event_handlers
	   Klass.set_OnInputChange_Handler(@handle, nil, nil)
	   Klass.set_OnVelocityChange_Handler(@handle, nil, nil)
	   Klass.set_OnPositionChange_Handler(@handle, nil, nil)
	   Klass.set_OnCurrentChange_Handler(@handle, nil, nil)
	end
  end
   
end