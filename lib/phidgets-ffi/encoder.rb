module Phidgets

  # This class represents a PhidgetEncoder
  class Encoder
 
    Klass = Phidgets::FFI::CPhidgetEncoder
    include Phidgets::Common
    
	# Collection of digital inputs
	# @return [EncoderDigitalInputs] 
    attr_reader :inputs
	
	# Collection of encoders
	# @return [EncoderEncoders] 
    attr_reader :encoders
	
	attr_reader :attributes
		
	# The attributes of a PhidgetEncoder
    def attributes
      super.merge({
        :inputs => inputs.size,
        :encoders => encoders.size,
    	})
    end

    # Sets an input change handler callback function. This is called when a digital input on the PhidgetEncoder board has changed.
    #
    # @param [String] obj Object to pass to the callback function. This is optional.
    # @param [Proc] Block When the callback is executed, the device and object are yielded to this block.
    # @example
    #     en.on_input_change do |device, input, state, obj|
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
    
    # Sets a position change handler callback function. This is called when an encoder position changes.
    #
    # @param [String] obj Object to pass to the callback function. This is optional.
    # @param [Proc] Block When the callback is executed, the device and object are yielded to this block.
    # @example
    #     en.on_position_change do |device, encoder, time, position_change, obj|
    #       puts "Encoder #{encoder.index} changed by #{position_change} - Time: #{time}"
    #     end
    # As this runs in it's own thread, be sure that all errors are properly handled or the thread will halt and not fire any more.
    # @return [Boolean] returns true or raises an error
    def on_position_change(obj=nil, &block)
      @on_position_change_obj = obj
      @on_position_change = Proc.new { |device, obj_ptr, index, time, position_change|
	    yield self, @encoders[index], time, position_change, object_for(obj_ptr)
	}
      Klass.set_OnPositionChange_Handler(@handle, @on_position_change, pointer_for(obj))
    end
	
 # This class represents a digital input a PhidgetEncoder. All the properties of an digital input are stored and modified in this class.
  class EncoderDigitalInputs 
    Klass = Phidgets::FFI::CPhidgetEncoder

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
  end #EncoderDigitalInputs
  
  # This class represents a encoder for a PhidgetEncoder. All the properties of an encoder are stored and modified in this class.
  class EncoderEncoders
    Klass = Phidgets::FFI::CPhidgetEncoder

	private
    def initialize(handle, index)
      @handle, @index = handle, index.to_i
    end

	public
	# Displays data for the encoder.
    def inspect
      "#<#{self.class} @index=#{index}, @position=#{position}>"
	
	end

	# @return [Integer] returns the index of the encoder, or raises an error.
	def index 
		@index
	end
	
	# @return [Integer] returns the index position for an encoder that supports index, or raises an error.
    def index_position
      ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getIndexPosition(@handle, @index, ptr)
      ptr.get_int(0)
    end

	# @return [Boolean] returns the enabled state of a encoder, or raises an error.
    def enabled
      ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getEnabled(@handle, @index, ptr)
      (ptr.get_int(0) == 0) ? false : true
    end

	# Sets the enabled state of an encoder, or raises an error.
	# @param [Boolean] new_state new state
	# @return [Boolean] returns enabled state of an encoder, or raises an error.
    def enabled=(new_state)
      tmp = new_state ? 1 : 0
      Klass.setEnabled(@handle, @index, tmp)
      new_state
    end

	# @return [Integer] returns the position of an encoder, or raises an error.
    def position
      ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getPosition(@handle, @index, ptr)
      ptr.get_int(0)
    end
	
	# Sets the position of an encoder, or raises an error.
	# @param [Integer] new_position new position
	# @return [Integer] returns the position of an encoder, or raises an error.
    def position=(new_position)
      Klass.setPosition(@handle, @index, new_position.to_i)
      new_position
    end	
	
  end #EncoderEncoders
  
	private
    
	def load_device_attributes
	  load_inputs
	  load_encoders
	end

    def load_inputs
	  ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getInputCount(@handle, ptr)
      @inputs = []
      ptr.get_int(0).times do |i|
        @inputs << EncoderDigitalInputs.new(@handle, i)
      end
    end

    def load_encoders
	  ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getEncoderCount(@handle, ptr)
      @encoders = []
      ptr.get_int(0).times do |i|
        @encoders << EncoderEncoders.new(@handle, i)
      end
    end

	def remove_specific_event_handlers
	   Klass.set_OnInputChange_Handler(@handle, nil, nil)
	   Klass.set_OnPositionChange_Handler(@handle, nil, nil)
	end
  end

end