module Phidgets
  module FFI
  
    attach_function :CPhidgetAnalog_create, [:phid], :int
	attach_function :CPhidgetAnalog_getOutputCount, [:phid, :pointer], :int 
	attach_function :CPhidgetAnalog_getVoltage, [:phid, :int, :pointer], :int 
	attach_function :CPhidgetAnalog_setVoltage, [:phid, :int, :double], :int 
	attach_function :CPhidgetAnalog_getVoltageMax, [:phid, :int, :pointer], :int 
	attach_function :CPhidgetAnalog_getVoltageMin, [:phid, :int, :pointer], :int     
	attach_function :CPhidgetAnalog_getEnabled, [:phid, :int, :pointer], :int 
	attach_function :CPhidgetAnalog_setEnabled, [:phid, :int, :int], :int 

	module CPhidgetAnalog
      def self.method_missing(method, *args, &block)
        if ::Phidgets::FFI.respond_to?("CPhidgetAnalog_#{method}".to_sym)
          if (rs = ::Phidgets::FFI.send("CPhidgetAnalog_#{method}".to_sym, *args, &block)) != 0
         
		    raise Phidgets::Error.exception_for(rs), Phidgets::FFI.error_description(rs)
          end
        else
          super(method, *args, &block)
        end
      end
    end 
  end
end



