module Phidgets
  module FFI
    LogLevel = enum(
      :critical, 1,
      :error,
      :warning,
      :debug,
      :info,
      :verbose
    )

    attach_function :CPhidget_enableLogging, [LogLevel, :string], :int #int CPhidget_enableLogging(CPhidgetLog_level level, const char *outputFile);
    attach_function :CPhidget_disableLogging, [], :int #int CPhidget_disableLogging();
    attach_function :CPhidget_log, [LogLevel, :string, :string, :varargs], :int #int CPhidget_log(CPhidgetLog_level level, const char *id, const char *message, ...);

    module Log
      def self.log(loglevel, identifier, message, *args)
        if !args.empty?
          ::Phidgets::FFI::CPhidget_log(loglevel, identifier, message, *args.to_varargs)
        else
          ::Phidgets::FFI::CPhidget_log(loglevel, identifier, message)
        end
      end
      
      def self.method_missing(method, *args, &block)
        if ::Phidgets::FFI.respond_to?("CPhidget_#{method}".to_sym)
          if (rs = ::Phidgets::FFI.send("CPhidget_#{method}".to_sym, *args, &block)) != 0
            raise Phidgets::Error.exception_for(rs), Phidgets::FFI.error_description(rs)
          end
        else
          super(method, *args, &block)
        end
      end
    end
  end
end