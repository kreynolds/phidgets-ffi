module Phidgets

  # This class represents a PhidgetAccelerometer.
  class Accelerometer
 
    Klass = Phidgets::FFI::CPhidgetAccelerometer
    include Phidgets::Common
    
	# Collection of accelerometer axes
	# @return [AccelerometerAxes] 
    attr_reader :axes

	attr_reader :attributes
	
	# The attributes of a PhidgetAccelerometer
    def attributes
      super.merge({
		  :axes => axes.size
      })
    end

    # Sets an acceleration change handler callback function. This is called when the acceleration of an axis changes by more than the set sensitivity.
    #
    # @param [String] obj Object to pass to the callback function. This is optional.
    # @param [Proc] Block When the callback is executed, the device and object are yielded to this block.
    # @example
    #     acc.on_acceleration_change do |device, axis, acceleration, obj|
    #       puts "Axis #{axis.index}'s acceleration changed to #{acceleration}"
    #     end
    # As this runs in it's own thread, be sure that all errors are properly handled or the thread will halt and not fire any more.
    # @return [Boolean] returns true or raises an error
    def on_acceleration_change(obj=nil, &block)
	  @on_acceleration_change_obj = obj
      @on_acceleration_change = Proc.new { |device, obj_ptr, ind, acc|
		yield self, axes[ind], acc, object_for(obj_ptr)
	}
      Klass.set_OnAccelerationChange_Handler(@handle, @on_acceleration_change, pointer_for(obj))
    end

	private
    
	def load_device_attributes
		load_axes
	end

    def load_axes

	  ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getAxisCount(@handle, ptr)
      @axes = []
      ptr.get_int(0).times do |i|
        @axes << AccelerometerAxes.new(@handle, i)
      end

    end

	def remove_specific_event_handlers
	   Klass.set_OnAccelerationChange_Handler(@handle, nil, nil)
	end
  
  # This class represents an axis of acceleration for a PhidgetAccelerometer. All the properties of an accelerometer axis are stored and modified in this class.
  class AccelerometerAxes
    Klass = Phidgets::FFI::CPhidgetAccelerometer
	
	private
    def initialize(handle, index)
      @handle, @index = handle, index.to_i
    end

	public

    # Displays data for the axis
    def inspect
      "#<#{self.class} @acceleration=#{acceleration}, @acceleration_max=#{acceleration_max}, @acceleration_min=#{acceleration_min}, @sensitivity=#{sensitivity}>"
	end

	# @return [Integer] returns index of the axis, or raises an error.
	def index 
		@index
	end
	
	# @return [Float] returns the acceleration value of the axis, or raises an error.
    def acceleration
      ptr = ::FFI::MemoryPointer.new(:double)
      Klass.getAcceleration(@handle, @index, ptr)
	  ptr.get_double(0)
    end
  
	# @return [Float] returns the largest acceleration value that the axis will return, or raises an error.
    def acceleration_max
      ptr = ::FFI::MemoryPointer.new(:double)
      Klass.getAccelerationMax(@handle, @index, ptr)
      ptr.get_double(0)
    end

	# @return [Float] returns the largest(negative) acceleration value that the axis will return, or raises an error.
    def acceleration_min
      ptr = ::FFI::MemoryPointer.new(:double)
      Klass.getAccelerationMin(@handle, @index, ptr)
      ptr.get_double(0)
    end

	# Sets the sensitivity of the acceleration data for the axis, or raises an error.
	# @param [Float] new_sensitivity new sensitivity
	# @return [Float] returns sensitivity of the acceleration data for the axis, or raises an error.
    def sensitivity=(new_sensitivity)
      Klass.setAccelerationChangeTrigger(@handle, @index, new_sensitivity.to_f)
      new_sensitivity.to_f
    end
		
	# @return [Float] returns sensitivity of the acceleration data for the axis, or raises an error.
    def sensitivity
      ptr = ::FFI::MemoryPointer.new(:double)
      Klass.getAccelerationChangeTrigger(@handle, @index, ptr)
      ptr.get_double(0)
    end

  end

 end
 end
  
