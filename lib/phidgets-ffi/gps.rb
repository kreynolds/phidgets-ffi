module Phidgets

  # This class represents a PhidgetGPS.
  class GPS
 
    Klass = Phidgets::FFI::CPhidgetGPS
    include Phidgets::Common
    
	# This represents the GPS date structure, in UTC
	#
	# Examples:
	#
	#  puts gps.date[:year]
	#  puts gps.date[:month]
	#  puts gps.date[:date]
	class GPS_date < ::FFI::Struct

		# Day
		# @return [Integer] returns the day
		attr_reader :day

		# Month
		# @return [Integer] returns the month
		attr_reader :month

		# Milliseconds
		# @return [Integer] returns the milliseconds
		attr_reader :year
		
		layout :day, :short,
		   :month, :short,
		   :year, :short 
	end
	

	# This represents the GPS time structure, in UTC
	#
	# Examples:
	#
	#  puts gps.time[:hours]
	#  puts gps.time[:minutes]
	#  puts gps.time[:seconds]
	#  puts gps.time[:milliseconds]
	class GPS_time < ::FFI::Struct
		
		# Milliseconds
		# @return [Integer] returns the milliseconds
		attr_reader :milliseconds
		
		# Seconds
		# @return [Integer] returns the seconds
		attr_reader :seconds
		
		# Minutes
		# @return [Integer] returns the minutes
		attr_reader :minutes
		
		# Hours
		# @return [Integer] returns the hours
		attr_reader :hours
		
		layout :milliseconds, :short,
		   :seconds, :short,
		   :minutes, :short, 
		   :hours, :short
	end
	
	attr_reader :attributes
		
	# The attributes of a PhidgetGPS
    def attributes
      super.merge({

      })
    end

    # Sets an position fix status change handler callback function. This is called when the position fix status changes.
    #
    # @param [String] obj Object to pass to the callback function. This is optional.
    # @param [Proc] Block When the callback is executed, the device and object are yielded to this block.
    # @example
    #     gps.on_position_fix_status_change do |device, fix_status, obj|
    #       puts "Position fix status changed to: #{fix_status}"
    #     end
    # As this runs in it's own thread, be sure that all errors are properly handled or the thread will halt and not fire any more.
    # @return [Boolean] returns true or raises an error
    def on_position_fix_status_change(obj=nil, &block)
	  @on_position_fix_status_change_obj = obj
      @on_position_fix_status_change = Proc.new { |device, obj_ptr, fix_status|
          yield self, (fix_status == 0 ? false : true), object_for(obj_ptr)
      }
      Klass.set_OnPositionFixStatusChange_Handler(@handle, @on_position_fix_status_change, pointer_for(obj))
    end

    # Sets position change handler callback function. This is called when the latitude, longitude, or altitude changes.
    #
    # @param [String] obj Object to pass to the callback function. This is optional.
    # @param [Proc] Block When the callback is executed, the device and object are yielded to this block.
    # @example
    #     gps.on_position_change do |device, lat, long, alt, obj|
    #       puts "Latitude: #{lat} degrees, longitude: #{long} degrees, altitude: #{alt} m"
    #     end
    # As this runs in it's own thread, be sure that all errors are properly handled or the thread will halt and not fire any more.
    # @return [Boolean] returns true or raises an error
    def on_position_change(obj=nil, &block)
	  @on_position_change_obj = obj
      @on_position_change = Proc.new { |device, obj_ptr, lat, long, alt|
        yield self, lat, long, alt, object_for(obj_ptr)
      }
      Klass.set_OnPositionChange_Handler(@handle, @on_position_change, pointer_for(obj))
    end

	# @return [Float] returns the latitude in degrees, or raises an error.
    def latitude
      ptr = ::FFI::MemoryPointer.new(:double)
      Klass.getLatitude(@handle, ptr)
      ptr.get_double(0)
    end

	# @return [Float] returns the longitude in degrees or raises an error.
    def longitude
      ptr = ::FFI::MemoryPointer.new(:double)
      Klass.getLongitude(@handle, ptr)
      ptr.get_double(0)
    end
	
	# @return [Float] returns the altitude in meters, or raises an error.
    def altitude
      ptr = ::FFI::MemoryPointer.new(:double)
      Klass.getAltitude(@handle, ptr)
      ptr.get_double(0)
    end

	# @return [Float] returns the heading in degrees or raises an error.
    def heading
      ptr = ::FFI::MemoryPointer.new(:double)
      Klass.getHeading(@handle, ptr)
      ptr.get_double(0)
    end

	# @return [Float] returns the velocity in km/h, in or raises an error.
    def velocity
      ptr = ::FFI::MemoryPointer.new(:double)
      Klass.getVelocity(@handle, ptr)
      ptr.get_double(0)
    end	
	
	# @return [GPS_date] returns the date in UTC, in or raises an error.
	def date
		ptr = ::FFI::MemoryPointer.new 6 #2 bytes for each short
		Klass.getDate(@handle, ptr)
		obj = GPS_date.new(ptr)
	end
	
	# @return [GPS_time] returns the time in UTC, in or raises an error.
	def time
		ptr = ::FFI::MemoryPointer.new 8 #2 bytes for each short
		Klass.getTime(@handle, ptr)
		obj = GPS_time.new(ptr)
	end
		
	# @return [Boolean] returns state of the digital input, or raises an error.
    def position_fix_status
      ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getPositionFixStatus(@handle, ptr)
      (ptr.get_int(0) == 0) ? false : true
    end
	
	private
    
	def load_device_attributes

	end

	def remove_specific_event_handlers
	   Klass.set_OnPositionChange_Handler(@handle, nil, nil)
	   Klass.set_OnPositionFixStatusChange_Handler(@handle, nil, nil)
	end
  end

end