module Phidgets

  # This class represents a PhidgetFrequencyCounter.
  class FrequencyCounter
 
    Klass = Phidgets::FFI::CPhidgetFrequencyCounter
    include Phidgets::Common
    
	# Collection of frequency counter inputs
	# @return [FrequencyCounterInputs] 
    attr_reader :inputs
	
	attr_reader :attributes
    
	# The attributes of a PhidgetFrequencyCounter
	def attributes
      super.merge({
        :inputs => inputs.size,
      })
    end

    # Sets an count handler callback function. This is called when ticks are counted on an frequency counter input, or when the timeout expires
    #
    # @param [String] obj Object to pass to the callback function. This is optional.
    # @param [Proc] Block When the callback is executed, the device and object are yielded to this block.
    # @example
    #     fc.on_count do |device, input, time, count, obj|
    #       puts "Channel  #{input.index}:  #{count} pulses in #{time} microseconds"
    #     end
    # As this runs in it's own thread, be sure that all errors are properly handled or the thread will halt and not fire any more.
    # @return [Boolean] returns true or raises an error
    def on_count(obj=nil, &block)
      @on_count_obj = obj
      @on_count = Proc.new { |device, obj_ptr, index, time, counts|
	    yield self, @inputs[index], time, counts, object_for(obj_ptr)
	}
      Klass.set_OnCount_Handler(@handle, @on_count, pointer_for(obj))
    end

 
  # This class represents a frequency counter input for a PhidgetFrequencyCounter. All the properties of a frequency counter input are stored and modified in this class.
  class FrequencyCounterInputs
    Klass = Phidgets::FFI::CPhidgetFrequencyCounter

	private
    def initialize(handle, index)
      @handle, @index = handle, index.to_i
    end
	
	public
	
	# @return [Integer] returns index of the frequency counter input, or raises an error.
	def index 
		@index
	end
	
	# @return [Boolean] returns the enabled state of a frequency counter input, or raises an error.
    def enabled
      ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getEnabled(@handle, @index, ptr)
      (ptr.get_int(0) == 0) ? false : true
    end

	# Sets the enabled state of a frequency counter input, or raises an error.
	# @param [Boolean] new_state new state
	# @return [Boolean] returns enabled state of a frequency counter input, or raises an error.
    def enabled=(new_state)
      tmp = new_state ? 1 : 0
      Klass.setEnabled(@handle, @index, tmp)
      new_state
    end
	
	# @return [Phidgets::FFI::FrequencyCounterFilterTypes] returns the filter type of the frequency counter input, or raises an error.
	def filter_type
      ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getFilter(@handle, @index, ptr)
      Phidgets::FFI::FrequencyCounterFilterTypes[ptr.get_int(0)]
    end

	# Sets the filter type of the frequency counter input, or raises an error. 
	# @param [Phidgets::FFI::FrequencyCounterFilterTypes] new_filter new filter
	# @return [Phidgets::FFI::FrequencyCounterFilterTypes] returns the filter type of the frequency counter input, or raises an error.
    def filter_type=(new_filter)
      ptr = ::FFI::MemoryPointer.new(:int)
      Klass.setFilter(@handle, @index, Phidgets::FFI::FrequencyCounterFilterTypes[new_filter])
      new_filter
    end
	
	# @return [Integer] returns the measured frequency of the frequency counter input, in Hz, or raises an error.
    def frequency
      ptr = ::FFI::MemoryPointer.new(:double)
      Klass.getFrequency(@handle, @index, ptr)
      ptr.get_double(0)
    end

	# @return [Integer] returns the timeout for the frequency counter input, in microseconds, or raises an error.
    def timeout
      ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getTimeout(@handle, @index, ptr)
      ptr.get_int(0)
    end

	# Sets the timeout for the frequency counter input, in microseconds, or raises an error.
	# @param [Integer] new_timeout new timeout
	# @return [Integer] returns timeout of the frequency counter input, or raises an error.
    def timeout=(new_timeout)
      Klass.setTimeout(@handle, @index, new_timeout.to_i)
      new_timeout.to_i
    end

	# @return [Integer] returns the number of ticks counted since last reset, or raises an error.
    def total_count
      ptr = ::FFI::MemoryPointer.new(:long)
      Klass.getTotalCount(@handle, @index, ptr)
      ptr.get_long(0)
    end

	# @return [Integer] returns the total time since last reset, in microseconds, or raises an error.
    def total_time
      ptr = ::FFI::MemoryPointer.new(:long_long)
      Klass.getTotalTime(@handle, @index, ptr)
      ptr.get_long_long(0)
    end
	
  end #FrequencyCounterInputs
    
	private
    
	def load_device_attributes
		load_inputs
	end
	
    def load_inputs
      ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getFrequencyInputCount(@handle, ptr)

      @inputs = []
      ptr.get_int(0).times do |i|
        @inputs << FrequencyCounterInputs.new(@handle, i)
      end
    end
	
	def remove_specific_event_handlers
	   Klass.set_OnCount_Handler(@handle, nil, nil)
	end
  end
   
end