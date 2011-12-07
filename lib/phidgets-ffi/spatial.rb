module Phidgets

  # This class represents a PhidgetSpatial.
  class Spatial
 
    Klass = Phidgets::FFI::CPhidgetSpatial
    include Phidgets::Common
	
	# Collection of accelerometer axes
	# @return [SpatialAccelerometerAxes] 
    attr_reader :accelerometer_axes

	# Collection of compass axes
	# @return [SpatialCompassAxes] 
    attr_reader :compass_axes

	# Collection of gyro axes
	# @return [SpatialGyroAxes] 
    attr_reader :gyro_axes	
	
	attr_reader :attributes
	
	# The attributes of a PhidgetSpatial
    def attributes
      super.merge({
		  :accelerometer_axes => accelerometer_axes.size,
		  :compass_axes => compass_axes.size,
		  :gyro_axes => gyro_axes.size
      })
    end

    # Sets a spatial data handler callback function. This is called at a fixed rate as determined by the data rate property. Contains data for acceleration/gyro/compass depending on what the board supports.
    #
    # @param [String] obj Object to pass to the callback function. This is optional.
    # @param [Proc] Block When the callback is executed, the device and object are yielded to this block.
    # @example
    #     spatial.on_spatial_data do |device, acceleration, magnetic_field, angular_rate, obj|
    #       puts "Acceleration: #{acceleration[0]},#{acceleration[1]}, #{acceleration[2]} | Magnetic field: #{magnetic_field[0]},#{magnetic_field[1]}, #{magnetic_field[2]} | Angular rate: #{angular_rate[0]},#{angular_rate[1]}, #{angular_rate[2]}"    #     end
    # As this runs in it's own thread, be sure that all errors are properly handled or the thread will halt and not fire any more.
    # @return [Boolean] returns true or raises an error
    def on_spatial_data(obj=nil, &block)
      @on_spatial_data_obj = obj
      @on_spatial_data = Proc.new { |device, obj_ptr, data, data_count|
		
	  acceleration = []
	  if accelerometer_axes.size > 0
	    acceleration = [accelerometer_axes[0].acceleration, accelerometer_axes[1].acceleration, accelerometer_axes[2].acceleration]
	  end

      magnetic_field= []
      if compass_axes.size > 0 
        #Even when there is a compass chip, sometimes there won't be valid data in the event.
		begin
          magnetic_field = [compass_axes[0].magnetic_field, compass_axes[1].magnetic_field, compass_axes[2].magnetic_field]
        rescue Phidgets::Error::UnknownVal => e
          magnetic_field = ['Unknown', 'Unknown', 'Unknown']
        end
      end

      angular_rate = []
      if gyro_axes.size > 0
        angular_rate = [gyro_axes[0].angular_rate, gyro_axes[1].angular_rate, gyro_axes[2].angular_rate]
      end
	
      yield self, acceleration, magnetic_field, angular_rate, object_for(obj_ptr)
	}
      Klass.set_OnSpatialData_Handler(@handle, @on_spatial_data, pointer_for(obj))
    end
	
	# Zeroes the gyro. This takes 1-2 seconds to complete and should only be called when the board is stationary.
	# @return [Boolean] returns true if successful, or raises an error.
    def zero_gyro
      Klass.zeroGyro(@handle)
	  true
    end

	# Resets correction parameters for the magnetometer triad. This returns magnetometer output to raw magnetic field strength. 
	# @return [Boolean] returns true if successful, or raises an error.
    def reset_compass_correction_parameters
      Klass.resetCompassCorrectionParameters(@handle)
	  true
    end

	# Sets correction paramaters for the magnetometer triad. This is for filtering out hard and soft iron offsets, and scaling the output to match the local field strength. These parameters can be obtained from the compass calibration program provided by Phidgets Inc.
	# @param [Integer] new_mag_field local magnetic field strength
	# @param [Integer] new_offset0 axis 0 offset correction
	# @param [Integer] new_offset1 axis 1 offset correction
	# @param [Integer] new_offset2 axis 2 offset correction
	# @param [Integer] new_gain0 axis 0 gain correction.
	# @param [Integer] new_gain1 axis 1 gain correction.
	# @param [Integer] new_gain2 axis 2 gain correction.
	# @param [Integer] new_t0 non-orthogonality correction factor 0
	# @param [Integer] new_t1 non-orthogonality correction factor 1
	# @param [Integer] new_t2 non-orthogonality correction factor 2
	# @param [Integer] new_t3 non-orthogonality correction factor 3
	# @param [Integer] new_t4 non-orthogonality correction factor 4
	# @param [Integer] new_t5 non-orthogonality correction factor 5
	# @return [Boolean] returns true if successful, or raises an error.
    def set_compass_correction_parameters(new_mag_field, new_offset0, new_offset1, new_offset2, new_gain0, new_gain1, new_gain2, new_t0, new_t1, new_t2, new_t3, new_t4, new_t5)
      Klass.setCompassCorrectionParameters(@handle, new_mag_field, new_offset0, new_offset1, new_offset2, new_gain0, new_gain1, new_gain2, new_t0, new_t1, new_t2, new_t3, new_t4, new_t5)
	  true
    end
	
	# @return [Integer] returns data rate in ms, or raises an error.
    def data_rate
      ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getDataRate(@handle, @index, ptr)
      ptr.get_int(0)
    end

	# Sets the data rate in ms, or raises an error.
	# @param [Integer] new_data_rate data rate
	# @return [Integer] returns the data rate in ms, or raises an error.
    def data_rate=(new_data_rate)
      Klass.setDataRate(@handle, @index, new_data_rate.to_i)
      new_data_rate.to_i
    end
	
	# @return [Integer] returns minimum data rate in ms, or raises an error.
    def data_rate_min
      ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getDataRateMin(@handle, @index, ptr)
      ptr.get_int(0)
    end

	# @return [Integer] returns maximum data rate in ms, or raises an error.
    def data_rate_max
      ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getDataRateMax(@handle, @index, ptr)
      ptr.get_int(0)
    end
	
	private
    
	def load_device_attributes
		load_acceleromter_axes
		load_compass_axes
		load_gyro_axes
	end

    def load_acceleromter_axes
	  ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getAccelerationAxisCount(@handle, ptr)
      @accelerometer_axes = []
      ptr.get_int(0).times do |i|
        @accelerometer_axes << SpatialAccelerometerAxes.new(@handle, i)
      end
	end

	def load_compass_axes
	  ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getCompassAxisCount(@handle, ptr)
      @compass_axes = []
      ptr.get_int(0).times do |i|
        @compass_axes << SpatialCompassAxes.new(@handle, i)
      end
	end
	
	def load_gyro_axes
	  ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getGyroAxisCount(@handle, ptr)
      @gyro_axes = []
      ptr.get_int(0).times do |i|
        @gyro_axes << SpatialGyroAxes.new(@handle, i)
      end
	end
	
  # This class represents an axis of acceleration for a PhidgetSpatial. All the properties of an accelerometer axis are stored and modified in this class.
  class SpatialAccelerometerAxes
    Klass = Phidgets::FFI::CPhidgetSpatial
	
	private
    def initialize(handle, index)
      @handle, @index = handle, index.to_i
    end

	public

    # Displays data for the accelerometer axis
    def inspect
      "#<#{self.class} @acceleration=#{acceleration}, @acceleration_max=#{acceleration_max}, @acceleration_min=#{acceleration_min}>"
	end

	# @return [Integer] returns index of the accelerometer axis, or raises an error.
	def index 
		@index
	end
	
	# @return [Float] returns the current acceleration in gs, or raises an error.
    def acceleration
      ptr = ::FFI::MemoryPointer.new(:double)
      Klass.getAcceleration(@handle, @index, ptr)
	  ptr.get_double(0)
    end
  
	# @return [Float] returns the maximum acceleration that the sensor can measure, or raises an error.
    def acceleration_max
      ptr = ::FFI::MemoryPointer.new(:double)
      Klass.getAccelerationMax(@handle, @index, ptr)
      ptr.get_double(0)
    end

	# @return [Float] returns the minimum acceleration that the sensor can measure, or raises an error.
    def acceleration_min
      ptr = ::FFI::MemoryPointer.new(:double)
      Klass.getAccelerationMin(@handle, @index, ptr)
      ptr.get_double(0)
    end

  end  #SpatialAccelerometerAxes

  # This class represents an axis of compass for a PhidgetSpatial. All the properties of an compass axis are stored and modified in this class.
  class SpatialCompassAxes
    Klass = Phidgets::FFI::CPhidgetSpatial
	
	private
    def initialize(handle, index)
      @handle, @index = handle, index.to_i
    end

	public

    # Displays data for the compass axis
    def inspect
      "#<#{self.class} @magnetic_field=#{magnetic_field}, @magnetic_field_max=#{magnetic_field_max}, @magnetic_field_min=#{magnetic_field_min}>"
	end

	# @return [Integer] returns index of the compass axis, or raises an error.
	def index 
		@index
	end
	
	# @return [Float] returns the magnetic field strength of the axis, in Gauss, or raises an error.
    def magnetic_field
      ptr = ::FFI::MemoryPointer.new(:double)
      Klass.getMagneticField(@handle, @index, ptr)
	  ptr.get_double(0)
    end
  
	# @return [Float] returns the maximum magnetic field strength measurable by the compass axis, or raises an error.
    def magnetic_field_max
      ptr = ::FFI::MemoryPointer.new(:double)
      Klass.getMagneticFieldMax(@handle, @index, ptr)
      ptr.get_double(0)
    end

	# @return [Float] returns the minimum magnetic field strength measurable by the compass axis, or raises an error.
    def magnetic_field_min
      ptr = ::FFI::MemoryPointer.new(:double)
      Klass.getMagneticFieldMin(@handle, @index, ptr)
      ptr.get_double(0)
    end

  end  #SpatialCompassAxes
  
    # This class represents an axis of gyroscope for a PhidgetSpatial. All the properties of an gyroscope axis are stored and modified in this class.
  class SpatialGyroAxes
    Klass = Phidgets::FFI::CPhidgetSpatial
	
	private
    def initialize(handle, index)
      @handle, @index = handle, index.to_i
    end

	public

    # Displays data for the gyroscope axis
    def inspect
      "#<#{self.class} @angular_rate=#{angular_rate}, @angular_rate_max=#{angular_rate_max}, @angular_rate_min=#{angular_rate_min}"
	end

	# @return [Integer] returns index of the gyroscope axis, or raises an error.
	def index 
		@index
	end
	
	# @return [Float] returns the angular rate of rotation for the gyro axis, in degress per second, or raises an error.
    def angular_rate
      ptr = ::FFI::MemoryPointer.new(:double)
      Klass.getAngularRate(@handle, @index, ptr)
	  ptr.get_double(0)
    end
  
	# @return [Float] returns the maximum supported angular rate for the gyro axis, or raises an error.
    def angular_rate_max
      ptr = ::FFI::MemoryPointer.new(:double)
      Klass.getAngularRateMax(@handle, @index, ptr)
      ptr.get_double(0)
    end

	# @return [Float] returns the minimum supported angular rate for the gyro axis, or raises an error.
    def angular_rate_min
      ptr = ::FFI::MemoryPointer.new(:double)
      Klass.getAngularRateMin(@handle, @index, ptr)
      ptr.get_double(0)
    end

  end  #SpatialGyroAxes

	def remove_specific_event_handlers
	   Klass.set_OnSpatialData_Handler(@handle, nil, nil)
	end
	
  end
 end
  
