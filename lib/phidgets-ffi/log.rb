module Phidgets
  class Log
    Klass = Phidgets::FFI::Log

	# Enables logging, or raises an error.
	# @param [Phidgets::FFI::LogLevel] level The highest level of logging to output. All lower levels will also be output.
	# @param [String] output_file File to output log to. This should be a full pathname, not a relative pathname. Optional. If no output file is specified, the output will print to console.
	# @return [Boolean] returns true, or raises an error.
    def self.enable(loglevel=:warning, filename=nil)
      Klass.enableLogging(loglevel, filename.to_s)
      true
    end

	# Disables logging, or raises an error.
	# @return [Boolean] returns true, or raises an error.
    def self.disable
      Klass.disableLogging
      true
    end
    
	# Appends a message to the log, or raises an error.
	# @param [Phidgets::FFI::LogLevel] level the level at which to log the message.
	# @param [String] output_file File to output log to. This should be a full pathname, not a relative pathname. Optional. If no output file is specified, the output will print to console.
	# @param [String] message the message
	# @return [Boolean] returns true, or raises an error.
    def self.log(loglevel, identifier, message, *args)
      Klass.log(loglevel, identifier, message, *args)
    end
    
	private
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
