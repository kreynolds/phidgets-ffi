module Phidgets

  # This class represents a CPhidgetRFID.
  class RFID
 
    Klass = Phidgets::FFI::CPhidgetRFID
    include Phidgets::Common
    
	# Collection of digital outputs
	# @return [RFIDOutputs] 
	attr_reader :outputs
	
	attr_reader :attributes
    
	# The attributes of a PhidgetRFID
	def attributes
      super.merge({
        :outputs => outputs.size,
		:antenna => antenna,
		:led => led,
      })
    end
	
    # Sets an output change handler callback function. This is called when a digital output on the PhidgetRFID board has changed.
    #
    # @param [String] obj Object to pass to the callback function. This is optional.
    # @param [Proc] Block When the callback is executed, the device and object are yielded to this block.
    # @example
    #     rfid.on_output_change do |device, output, state, obj|
    #       print "Digital Output  #{output.index}, changed to #{state}\n"
    #     end
    # As this runs in it's own thread, be sure that all errors are properly handled or the thread will halt and not fire any more.
    # @return [Boolean] returns true or raises an error
    def on_output_change(obj=nil, &block)
      @on_output_change_obj = obj
      @on_output_change = Proc.new { |device, obj_ptr, index, state|
        yield self, @outputs[index], (state == 0 ? false : true), object_for(obj_ptr)
      }
      Klass.set_OnOutputChange_Handler(@handle, @on_output_change, pointer_for(obj))
    end
	
    # Sets a tag handler callback function. This is called when a new tag is seen by the reader. The event is only fired one time for a new tag, so the tag has to be removed and then replaced before another tag gained event will fire.
    #
    # @param [String] obj Object to pass to the callback function. This is optional.
    # @param [Proc] Block When the callback is executed, the device and object are yielded to this block.
    # @example
    #     rfid.on_tag do |device, tag, obj|
    #       puts "Tag #{tag} detected"
    #     end
    # As this runs in it's own thread, be sure that all errors are properly handled or the thread will halt and not fire any more.
    # @return [Boolean] returns true or raises an error
    def on_tag(obj=nil, &block)
	  @on_tag_obj = obj
      @on_tag = Proc.new { |device, obj_ptr, tag, proto|
		yield self, tag.read_string, object_for(obj_ptr)
	}
      Klass.set_OnTag2_Handler(@handle, @on_tag, pointer_for(obj))
    end
	
    # Sets a tag lost handler callback function. This is called when a tag is removed from the reader
    #
    # @param [String] obj Object to pass to the callback function. This is optional.
    # @param [Proc] Block When the callback is executed, the device and object are yielded to this block.
    # @example
    #     rfid.on_tag_lost do |device, tag, obj|
    #       puts "Tag #{tag} removed"
    #     end
    # As this runs in it's own thread, be sure that all errors are properly handled or the thread will halt and not fire any more.
    # @return [Boolean] returns true or raises an error
    def on_tag_lost(obj=nil, &block)
	  @on_tag_lost_obj = obj
      @on_tag_lost = Proc.new { |device, obj_ptr, tag, proto|
	    yield self, tag.read_string, object_for(obj_ptr)
	}
      Klass.set_OnTagLost2_Handler(@handle, @on_tag_lost, pointer_for(obj))
    end

    # Returns the antenna state of the Phidget.
    #
    # @return [Boolean] returns the ratiometric state or raises an error
    def antenna
      ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getAntennaOn(@handle, ptr)
      (ptr.get_int(0) == 0) ? false : true
    end

    # Sets the antenna state of the Phidget. True turns the antenna on, false turns it off. The antenna if by default turned off, and needs to be explicitely activated before tags can be read. Control over the antenna allows multiple readers to be used in close proximity, as multiple readers will interfere with each other if their antenna's are activated simultaneously.
    # @param [Boolean] new_state new antenna state
    # @return [Boolean] returns the antenna state, or raises an error
    def antenna=(new_state)
      tmp = new_state ? 1 : 0
      Klass.setAntennaOn(@handle, tmp)
      new_state
    end
	
    # Returns the LED state.
    #
    # @return [Boolean] returns the LED state or raises an error
    def led
      ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getLEDOn(@handle, ptr)
      (ptr.get_int(0) == 0) ? false : true
    end

    # Sets the LED. True turns the LED on, false turns it off. The LED is by default turned off.
    # @param [Boolean] new_state new LED state
    # @return [Boolean] returns the LED state or raises an error
    def led=(new_state)
      tmp = new_state ? 1 : 0
      Klass.setLEDOn(@handle, tmp)
      new_state
    end
	
    # Returns the last tag read by the reader. This may or may not still be on the reader - use {Phidgets::RFID#tag_present} to find out.
    #
    # @return [String] returns the last tag or raises an error
    def last_tag
      tag = ::FFI::MemoryPointer.new(:string)
	  proto = ::FFI::MemoryPointer.new(:int)
      Klass.getLastTag2(@handle, tag, proto)
      strPtr = tag.get_pointer(0)
      strPtr.null? ? nil : strPtr.read_string
	end
	
	# Returns the protocol of the last tag read by the reader. This may or may not still be on the reader - use {Phidgets::RFID#tag_present} to find out.
    #
    # @return [Phidgets::FFI::RFIDTagProtocol] returns the last tag protocol or raises an error
    def last_tag_protocol
      tag = ::FFI::MemoryPointer.new(:string)
	  proto = ::FFI::MemoryPointer.new(:int)
      Klass.getLastTag2(@handle, tag, proto)
      Phidgets::FFI::RFIDTagProtocol[proto.get_int(0)]
	end
	
	# Returns the value indicating whether or not a tag is on the reader.
    #
    # @return [Boolean] returns a value indicating whether or not a tag is on the reader, or raises an error
    def tag_present
      ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getTagStatus(@handle, ptr)
      (ptr.get_int(0) == 0) ? false : true
    end
	
	# Writes to a tag.
	#
	# @param [String] tag Tag data to write. See product manual for formatting.
	# @param [Phidgets::FFI::RFIDTagProtocol] protocol Tag Protocol to use.
	# @param [Boolean] lock Lock the tag from further writes
	# @return [Boolean] returns true or raises an error
	def write(tag, protocol, lock=false)
      tmp = lock ? 1 : 0
	  Klass.write(@handle, tag,  Phidgets::FFI::RFIDTagProtocol[protocol], tmp)
	  true
	end
	
  # This class represents an digital output for a PhidgetRFID All the properties of an digital output are stored and modified in this class.
  class RFIDOutputs
    Klass = Phidgets::FFI::CPhidgetRFID

	private
    def initialize(handle, index)
      @handle, @index = handle, index.to_i
    end

	public
	
	# Displays data for the digital output
    def inspect
      "#<#{self.class} @index=#{index}, @state=#{state}>"
    end
	
    # @return [Integer] returns index of the digital output, or raises an error.
	def index 
		@index
	end
	
	# Sets the state of the digital output, or raises an error.
	# @param [Boolean] new_state new state
	# @return [Boolean] sets the state of the digital output, or raises an error.
	def state=(new_state)
      tmp = new_state ? 1 : 0
      Klass.setOutputState(@handle, @index, tmp)
      new_state
    end

	# @return [Boolean] returns state of the digital output, or raises an error.
    def state
      ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getOutputState(@handle, @index, ptr)
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
        @outputs << RFIDOutputs.new(@handle, i)
      end
    end
	
	def remove_specific_event_handlers
	   Klass.set_OnOutputChange_Handler(@handle, nil, nil)
	   Klass.set_OnTag2_Handler(@handle, nil, nil)
	   Klass.set_OnTagLost2_Handler(@handle, nil, nil)
	end
	
  end
   
end