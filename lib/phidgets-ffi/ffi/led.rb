module Phidgets
  module FFI

   LEDCurrentLimit = enum(
      :current_limit_20mA, 1,
      :current_limit_40mA,
      :current_limit_60mA,
      :current_limit_80mA,
      :invalid
    )

	LEDVoltage = enum(
      :voltage_1_7V, 1,
      :voltage_2_75V,
      :voltage_3_9V,
      :voltage_5_0V
    )
	
	attach_function :CPhidgetLED_create, [:phid], :int
    attach_function :CPhidgetLED_getLEDCount, [:phid, :pointer], :int 
    attach_function :CPhidgetLED_getDiscreteLED, [:phid, :int, :pointer], :int 
	attach_function :CPhidgetLED_setDiscreteLED, [:phid, :int, :int], :int 
    attach_function :CPhidgetLED_getCurrentLimit, [:phid, :pointer], :int 
	attach_function :CPhidgetLED_setCurrentLimit, [:phid, LEDCurrentLimit], :int     
    attach_function :CPhidgetLED_getVoltage, [:phid, :pointer], :int 
	attach_function :CPhidgetLED_setVoltage, [:phid, LEDVoltage], :int     

module CPhidgetLED
      def self.method_missing(method, *args, &block)
        if ::Phidgets::FFI.respond_to?("CPhidgetLED_#{method}".to_sym)
          if (rs = ::Phidgets::FFI.send("CPhidgetLED_#{method}".to_sym, *args, &block)) != 0
            raise Phidgets::Error.exception_for(rs), Phidgets::FFI.error_description(rs)
          end
        else
          super(method, *args, &block)
        end
      end
    end
  end
end