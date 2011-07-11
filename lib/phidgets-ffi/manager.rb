module Phidgets
  class Manager
    Klass = Phidgets::FFI::CPhidgetManager
    
    def initialize(&block)
      ptr = ::FFI::MemoryPointer.new(:pointer, 1)
      Klass.create(ptr)
        
      @handle = ptr.get_pointer(0)
      if block_given?
        open
        yield self
        close
        delete
      end
    end
    
    def create
      ptr = ::FFI::MemoryPointer.new(:pointer, 1)
      Klass.create(ptr)        
      @handle = ptr.get_pointer(0)
      true
    end

    def open
      Klass.open(@handle)
      true
    end
    
    def close
      Klass.close(@handle)
      true
    end

    def delete
      Klass.delete(@handle)
      true
    end

    
  end
end