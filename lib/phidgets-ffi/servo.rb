module Phidgets
  class ServoController

    Klass = Phidgets::FFI::CPhidgetServo
    include Phidgets::Common
    
    attr_reader :servos

    def initialize(serial_number=-1, &block)
      create
      open(serial_number)
      wait_for_attachment
      load_servos
      if block_given?
        yield self
        close
        delete
      end
    end
    
    def attributes
      super.merge({
        :servos => servos.size,
      })
    end

    def on_change(obj=nil, &block)
      @on_change_obj = obj
      @on_change = Proc.new { |device, obj_ptr, index, position|
        yield @servos[index], position, object_for(obj_ptr)
      }
      Klass.set_OnPositionChange_Handler(@handle, @on_change, pointer_for(obj))
    end

    private
    
    def load_servos
      ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getMotorCount(@handle, ptr)

      @servos = []
      ptr.get_int(0).times do |i|
        @servos << Servo.new(@handle, i)
      end
    end
  end
  
  class Servo
    Klass = Phidgets::FFI::CPhidgetServo

    attr_reader :index
    
    def initialize(handle, index)
      @handle, @index = handle, index.to_i
    end
    
    def engaged
      ptr = ::FFI::MemoryPointer.new(:int, 1)
      Klass.getEngaged(@handle, @index, ptr)
      (ptr.get_int(0) == 0) ? false : true
    end
    alias_method :engaged?, :engaged
    
    def engaged=(val)
      tmp = val ? 1 : 0
      Klass.setEngaged(@handle, @index, tmp)

      val
    end
    
    def max
      ptr = ::FFI::MemoryPointer.new(:double, 1)
      Klass.getPositionMax(@handle, @index, ptr)
      ptr.get_double(0)
    end
    
    def min
      ptr = ::FFI::MemoryPointer.new(:double, 1)
      Klass.getPositionMin(@handle, @index, ptr)
      ptr.get_double(0)
    end
    
    def position
      ptr = ::FFI::MemoryPointer.new(:double, 1)
      Klass.getPosition(@handle, @index, ptr)
      ptr.get_double(0)
    end

    def position=(new_position)
      Klass.setPosition(@handle, @index, new_position.to_f)
      new_position
    end
    
    def type
      ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getServoType(@handle, @index, ptr)
      
      Phidgets::FFI::ServoType[ptr.get_int(0)]
    end

    def type=(servo_type=:default)
      ptr = ::FFI::MemoryPointer.new(:int)
      Klass.setServoType(@handle, @index, Phidgets::FFI::ServoType[servo_type])
      servo_type
    end
    
    def set_parameters(min_pcm, max_pcm, degrees)
      Klass.setServoParameters(@handle, @index, min_pcm.to_f, max_pcm.to_f, degrees.to_f)
      true
    end
  end
end