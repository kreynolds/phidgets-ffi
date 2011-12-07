module Phidgets

  # This class represents a PhidgetIR.
  class IR
 
    Klass = Phidgets::FFI::CPhidgetIR
    include Phidgets::Common
    
	# This represents the encoding parameters needed to transmit a code.
	#
	# Examples:
	#
	#  puts ir.code_info[:bit_count]
	#  puts ir.code_info[:encoding]	
	#  puts ir.code_info[:length]
	#  puts ir.code_info[:gap]
	#  puts ir.code_info[:trail]
	#  puts ir.code_info[:header]
	#  puts ir.code_info[:one]
	#  puts ir.code_info[:zero]
	#  puts ir.code_info[:repeat]
	#  puts ir.code_info[:min_repeat]
	#  puts ir.code_info[:toggle_mask]
	#  puts ir.code_info[:carrier_frequency]
	#  puts ir.code_info[:duty_cycle]
	class IR_code_info < ::FFI::Struct
		
		# Number of bits in the code
		# @return [Integer] returns the number of bits
		attr_accessor :bit_count

		# Encoding used to encode the data
		# @return [Phidgets::FFI::IREncoding] returns the encoding type
		attr_accessor :encoding
		
		# Constant or variable length encoding
		# @return [Phidgets::FFI::IRLength] returns the length type
		attr_accessor :length
		
		# Gap time in us
		# @return [Integer] returns the gap time
		attr_accessor :gap
		
		# Trail time in us - can be 0 for none
		# @return [Integer] returns the the trail time
		attr_accessor :trail
		
		# Header pulse and space - can be 0 for none
		# @return [FFI::Struct::InlineArray[2<Integer>]] returns the header
		attr_accessor :header
		
		# Pulse and space times to represent a '1' bit, in us
		# @return [FFI::Struct::InlineArray[2<Integer>]] returns the pulse and space times
		attr_accessor :one
		
		# Pulse and space times to represent a '0' bit, in us
		# @return [FFI::Struct::InlineArray[2<Integer>]] returns the pulse and space times
		attr_accessor :zero
		
		# A series or pulse and space times to represent the repeat code. Start and end with pulses and null terminate - can be 0 for none
		# @return [FFI::Struct::InlineArray[26<Integer>]] returns the repeat code
		attr_accessor :repeat
		
		# Minimum number of times to repeat a code on transmit
		# @return [Integer] returns the minimum repeat
		attr_accessor :min_repeat
		
		# Bit toggles, which are applied to the code after each transmit
		# @return [FFI::StructLayout::CharArray[16<Integer>]] returns the bit toggles
		attr_accessor :toggle_mask
		
		# Carrier frequency in Hz - defaults to 38kHz
		# @return [Integer] returns the carrier frequency
		attr_accessor :carrier_frequency
		
		# Duty cycle in precent(10-50%) - defaults to 33
		# @return [Integer] returns the duty cycle
		attr_accessor :duty_cycle
		
		layout :bit_count, :int,
			:encoding, Phidgets::FFI::IREncoding,
			:length, Phidgets::FFI::IRLength, 
			:gap, :int,
			:trail, :int,
			:header, [:int, 2],
			:one, [:int, 2],
			:zero, [:int, 2],
			:repeat, [:int, 26],
			:min_repeat, :int,
			:toggle_mask, [:uchar, 16],
		    :carrier_frequency, :int,
		    :duty_cycle, :int
		
	end

    # Sets a raw data handler callback function. This is called whenever a new IR data is available.  Data is in the form of an array of microsecond pulse values. This can be used if the user wishes to do their own data decoding, or for codes that the PhidgetIR cannot automatically recognize.
    #
    # @param [String] obj Object to pass to the callback function. This is optional.
    # @param [Proc] Block When the callback is executed, the device and object are yielded to this block.
    # @example
    #   ir.on_raw_data do |device, raw_data, data_length, obj|
    #	    puts "Raw data: #{raw_data}, length: #{data_length}"
    #   end
    # As this runs in it's own thread, be sure that all errors are properly handled or the thread will halt and not fire any more.
    # @return [Boolean] returns true or raises an error
    def on_raw_data(obj=nil, &block)
	  @on_raw_data_obj = obj
      @on_raw_data = Proc.new { |device, obj_ptr, raw_data, data_length|
		data = []
		data_length.times { |i|		
			data << raw_data[i].get_int(0)
		}
		
	    yield self, data, data_length, object_for(obj_ptr)
	}
      Klass.set_OnRawData_Handler(@handle, @on_raw_data, pointer_for(obj))
    end

    # Sets a code handler callback function. This is called whenever a new code is recognized.
    #
    # @param [String] obj Object to pass to the callback function. This is optional.
    # @param [Proc] Block When the callback is executed, the device and object are yielded to this block.
    # @example
    #   ir.on_code do |device, data, data_length, bit_count, repeat, obj|
    #	    puts "Code #{data} received, length: #{data_length}, bit count: #{bit_count}, repeat: #{repeat}"
    #   end
    # As this runs in it's own thread, be sure that all errors are properly handled or the thread will halt and not fire any more.
    # @return [Boolean] returns true or raises an error
    def on_code(obj=nil, &block)
	  @on_code_obj = obj
      @on_code = Proc.new { |device, obj_ptr, data, data_length, bit_count, repeat|
		data_string = []
		data_length.times { |i|
			data_string[i] = data[i].get_uchar(0).to_s(16)
		}
		
	    yield self, data_string, data_length, bit_count, repeat, object_for(obj_ptr)
	}
      Klass.set_OnCode_Handler(@handle, @on_code, pointer_for(obj))
    end

    # Sets a learn handler callback function. This is called when a new code has been learned. This generally requires the button to be held down for a second or two.
    #
    # @param [String] obj Object to pass to the callback function. This is optional.
    # @param [Proc] Block When the callback is executed, the device and object are yielded to this block.
    # @example
    #   ir.on_learn do |device, data, data_length, code_info, obj|
    #     puts "Code #{data} learnt"
    #   end
    # As this runs in it's own thread, be sure that all errors are properly handled or the thread will halt and not fire any more.
    # @return [Boolean] returns true or raises an error
    def on_learn(obj=nil, &block)
      @on_learn_obj = obj
      @on_learn = Proc.new { |device, obj_ptr, int_data, data_length, code_info|
		data = []
		data_length.times { |i|
			data[i] = int_data[i].get_uchar(0).to_s(16)
		}
		
		code_info_struct = IR_code_info.new(code_info)	
				
	    yield self, data, data_length, code_info_struct, object_for(obj_ptr)
	}
      Klass.set_OnLearn_Handler(@handle, @on_learn, pointer_for(obj))
    end

	# Transmits a code
	# @param [Array<String>] data data to send
	# @param [IR_code_info] code_info code info structure specifying the attributes of the code to send. Anything that is not set is set to default. 
	# @return [Boolean] returns true if the code was successfully transmitted, or raises an error.	
	def transmit(data, code_info)
   
		pdata = ::FFI::MemoryPointer.new(:uchar, 16)
				
		data_ffi = []
		data.size.times { |i|
			data_ffi[i] = data[i].to_i(16)
		}
		
		data_ffi = ::FFI::MemoryPointer.new(:uchar, 16).write_array_of_uchar(data_ffi)
			
		Klass.Transmit(@handle, data_ffi, code_info)  
		true
   end
   
	# Transmits a repeat of a previously transmitted code, or raises an error.
	# @return [Boolean] returns true if the code was successfully transmitted, or raises an error.	
	def transmit_repeat
		Klass.TransmitRepeat(@handle)
	  true
    end

	# Transmits raw data as a series of pulses and spaces.
	# @param [Array] data data to send
	# @param [Integer] length length of the data array 
	# @param [Integer] carrier_frequency carrier frequency in Hz. Leave as 0 for default
	# @param [Integer] duty_cycle duty cycle(10-50). Leave as 0 for default
	# @param [Integer] gap_time gap time in us. This guarantees a gap time(no transmitting) after the data is sent, but can be set to 0
	# @return [Boolean] returns true if the raw data was successfully transmitted, or raises an error.
   def transmit_raw(data, length, carrier_frequency, duty_cycle, gap)
		c_data = ::FFI::MemoryPointer.new(:int, data.size).write_array_of_int(data)
		Klass.TransmitRaw(@handle, c_data, length.to_i, carrier_frequency.to_i, duty_cycle.to_i, gap.to_i)
		true
   end

	# Reads any available raw data. This should be polled continuously(every 20ms) to avoid missing data. Read data always starts with a space and ends with a pulse.
	# @return [Array<Integer>] returns true if the raw data was successfully transmitted, or raises an error.
	# @return [Integer] returns the data length, or raises an error.
	def read_raw_data
		data_ffi = ::FFI::MemoryPointer.new(:int, 16)

		data_length = ::FFI::MemoryPointer.new(:int)
		data_length.write_int(16)

		Klass.getRawData(@handle, data_ffi, data_length)
		
		data = []
		
		data_length.get_int(0).times { |i|
			data << data_ffi[i].get_int(0)
		}
		
		[data, data_length.get_int(0)]
	end

	# Gets the last code that was received.
	# @return [Array<String>] returns the last code, or raises an error.
	# @return [Integer] returns the data length, or raises an error.
	# @return [Object] returns the bit count, or raises an error.
	def last_code
		data_ffi = ::FFI::MemoryPointer.new(:uchar, 16)
		
		data_length = ::FFI::MemoryPointer.new(:int)
		data_length.write_int(16)

		bit_count = ::FFI::MemoryPointer.new(:int)
		
		Klass.getLastCode(@handle, data_ffi, data_length, bit_count)

		data = []
		
		data_length.get_int(0).times { |i|
			 data << data_ffi[i].get_uchar(0).to_s(16)
		}
		
      [data, data_length.get_int(0), bit_count.get_int(0)]

    end
	
	# Gets the last code that was learned.
	# @return [Array<String>] returns the last learned code, or raises an error.
	# @return [Integer] returns the data length, or raises an error.
	# @return [IR_code_info] returns the code info structure for the learned code, or raises an error.
	def last_learned_code
	
		data_ffi = ::FFI::MemoryPointer.new(:uchar, 16)
		
		data_length = ::FFI::MemoryPointer.new(:int)
		data_length.write_int(16)

		code_info = ::FFI::MemoryPointer.new(IR_code_info)
		
		Klass.getLastLearnedCode(@handle, data_ffi, data_length, code_info)
		
		data = []
		
		data_length.get_int(0).times { |i|
			 data << data_ffi[i].get_uchar(0).to_s(16)
		}
	
        code_info_struct = IR_code_info.new(code_info)	
	
		[data, data_length.get_int(0), code_info_struct]		
			
	end
    
	private
    
	def load_device_attributes

	end

	def remove_specific_event_handlers
		Klass.set_OnCode_Handler(@handle, nil, nil)
		Klass.set_OnLearn_Handler(@handle, nil, nil)
		Klass.set_OnRawData_Handler(@handle, nil, nil)
	end
  end
   
end