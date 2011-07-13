module Phidgets
  class InterfaceKit

    Klass = Phidgets::FFI::CPhidgetInterfaceKit
    include Phidgets::Common
    
    attr_reader :inputs, :outputs, :sensors

    def initialize(serial_number=-1, &block)
      create
      open(serial_number)
      wait_for_attachment
      load_inputs
      load_outputs
      load_sensors
      if block_given?
        yield self
        close
        delete
      end
    end
    
    def attributes
      super.merge({
        :inputs => inputs.size,
        :outputs => outputs.size,
        :sensors => sensors.size,
      })
    end

    def on_input_change(obj=nil, &block)
      @on_input_change_obj = obj
      @on_input_change = Proc.new { |device, obj_ptr, index, state|
        yield @inputs[index], (state == 0 ? false : true), object_for(obj_ptr)
      }
      Klass.set_OnInputChange_Handler(@handle, @on_input_change, pointer_for(obj))
    end
    
    def on_output_change(obj=nil, &block)
      @on_output_change_obj = obj
      @on_output_change = Proc.new { |device, obj_ptr, index, state|
        yield @outputs[index], (state == 0 ? false : true), object_for(obj_ptr)
      }
      Klass.set_OnOutputChange_Handler(@handle, @on_output_change, pointer_for(obj))
    end
    
    def on_sensor_change(obj=nil, &block)
      @on_sensor_change_obj = obj
      @on_sensor_change = Proc.new { |device, obj_ptr, index, value|
        yield @sensors[index], value, object_for(obj_ptr)
      }
      Klass.set_OnSensorChange_Handler(@handle, @on_sensor_change, pointer_for(obj))
    end

    def ratiometric
      ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getRatiometric(@handle, ptr)
      (ptr.get_int(0) == 0) ? false : true
    end
    alias_method :ratiometric?, :ratiometric

    def ratiometric=(val)
      tmp = val ? 1 : 0
      Klass.setRatiometric(@handle, tmp)

      val
    end
    private
    
    def load_inputs
      ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getInputCount(@handle, ptr)

      @inputs = []
      ptr.get_int(0).times do |i|
        @inputs << InterfaceKitInput.new(@handle, i)
      end
    end

    def load_outputs
      ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getOutputCount(@handle, ptr)

      @outputs = []
      ptr.get_int(0).times do |i|
        @outputs << InterfaceKitOutput.new(@handle, i)
      end
    end

    def load_sensors
      ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getSensorCount(@handle, ptr)

      @sensors = []
      ptr.get_int(0).times do |i|
        @sensors << InterfaceKitSensor.new(@handle, i)
      end
    end
  end

  class InterfaceKitInput
    Klass = Phidgets::FFI::CPhidgetInterfaceKit

    attr_reader :index

    def initialize(handle, index)
      @handle, @index = handle, index.to_i
    end

    def state
      ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getInputState(@handle, @index, ptr)
      (ptr.get_int(0) == 0) ? false : true
    end
  end

  class InterfaceKitOutput
    Klass = Phidgets::FFI::CPhidgetInterfaceKit

    attr_reader :index

    def initialize(handle, index)
      @handle, @index = handle, index.to_i
    end

    def state=(val)
      tmp = val ? 1 : 0
      Klass.setOutputState(@handle, @index, tmp)

      val
    end

    def state
      ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getOutputState(@handle, @index, ptr)
      (ptr.get_int(0) == 0) ? false : true
    end

    def on
      state == true
    end
    alias_method :on?, :state
    
    def off
      !on
    end
    alias_method :off?, :off
  end

  class InterfaceKitSensor
    Klass = Phidgets::FFI::CPhidgetInterfaceKit

    attr_reader :index

    def initialize(handle, index)
      @handle, @index = handle, index.to_i
    end

    def inspect
      "#<#{self.class} @value=#{value}, @raw_value=#{raw_value}, @rate=#{rate}, @trigger=#{trigger}, @max_rate=#{max_rate}, @min_rate=#{min_rate}>"
    end

    def value
      ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getSensorValue(@handle, @index, ptr)
      ptr.get_int(0)
    end
    alias_method :to_i, :value

    def raw_value
      ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getSensorRawValue(@handle, @index, ptr)
      ptr.get_int(0)
    end

    def trigger
      ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getSensorChangeTrigger(@handle, @index, ptr)
      ptr.get_int(0)
    end

    def trigger=(val)
      Klass.setSensorChangeTrigger(@handle, @index, val.to_i)

      val.to_i
    end

    def max_rate
      ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getDataRateMax(@handle, @index, ptr)
      ptr.get_int(0)
    end

    def min_rate
      ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getDataRateMin(@handle, @index, ptr)
      ptr.get_int(0)
    end

    def rate
      ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getDataRate(@handle, @index, ptr)
      ptr.get_int(0)
    end

    def rate=(val)
      Klass.setDataRate(@handle, @index, val.to_i)

      val.to_i
    end
  end
end