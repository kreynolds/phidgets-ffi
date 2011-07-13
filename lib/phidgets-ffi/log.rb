module Phidgets
  class Log
    Klass = Phidgets::FFI::Log

    def self.enable(loglevel=:warning, filename=nil)
      Klass.enableLogging(loglevel, filename.to_s)
      true
    end

    def self.disable
      Klass.disableLogging
      true
    end
    
    def self.log(loglevel, identifier, message, *args)
      Klass.log(loglevel, identifier, message, *args)
    end
    
    def self.method_missing(method, *args, &block)
      if Phidgets::FFI::LogLevel.symbols.include?(method)
        log(method, *args)
        true
      else
        super(method, *args, &block)
      end
    end
  end
end
