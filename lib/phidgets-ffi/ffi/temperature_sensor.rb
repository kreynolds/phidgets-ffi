module Phidgets
  module FFI

   TemperatureSensorThermocoupleTypes = enum(
      :thermocouple_type_k_type, 1,
      :thermocouple_type_j_type,
      :thermocouple_type_e_type,
	  :thermocouple_type_t_type
    )

	attach_function :CPhidgetTemperatureSensor_create, [:phid], :int
    attach_function :CPhidgetTemperatureSensor_getTemperatureInputCount, [:phid, :pointer], :int 
    attach_function :CPhidgetTemperatureSensor_getTemperature, [:phid, :int, :pointer], :int 
    attach_function :CPhidgetTemperatureSensor_getTemperatureMax, [:phid, :int, :pointer], :int 	
	attach_function :CPhidgetTemperatureSensor_getTemperatureMin, [:phid, :int, :pointer], :int 	
    attach_function :CPhidgetTemperatureSensor_getTemperatureChangeTrigger, [:phid, :int, :pointer], :int 
	attach_function :CPhidgetTemperatureSensor_setTemperatureChangeTrigger, [:phid, :int, :double], :int 
	attach_function :CPhidgetTemperatureSensor_getPotential, [:phid, :int, :pointer], :int 
    attach_function :CPhidgetTemperatureSensor_getPotentialMax, [:phid, :int, :pointer], :int 
    attach_function :CPhidgetTemperatureSensor_getPotentialMin, [:phid, :int, :pointer], :int 
	attach_function :CPhidgetTemperatureSensor_getAmbientTemperature, [:phid, :pointer], :int 
	attach_function :CPhidgetTemperatureSensor_getAmbientTemperatureMax, [:phid, :pointer], :int 
	attach_function :CPhidgetTemperatureSensor_getAmbientTemperatureMin, [:phid, :pointer], :int 
	attach_function :CPhidgetTemperatureSensor_getThermocoupleType, [:phid, :int, :pointer], :int     
	attach_function :CPhidgetTemperatureSensor_setThermocoupleType, [:phid, :int, TemperatureSensorThermocoupleTypes], :int 
 
	callback :CPhidgetTemperatureSensor_set_OnTemperatureChange_Callback, [:phid, :user_ptr, :int, :double], :int
    attach_function :CPhidgetTemperatureSensor_set_OnTemperatureChange_Handler, [:phid, :CPhidgetTemperatureSensor_set_OnTemperatureChange_Callback, :user_ptr], :int 
	
module CPhidgetTemperatureSensor
      def self.method_missing(method, *args, &block)
        if ::Phidgets::FFI.respond_to?("CPhidgetTemperatureSensor_#{method}".to_sym)
          if (rs = ::Phidgets::FFI.send("CPhidgetTemperatureSensor_#{method}".to_sym, *args, &block)) != 0
            raise Phidgets::Error.exception_for(rs), Phidgets::FFI.error_description(rs)
          end
        else
          super(method, *args, &block)
        end
      end
    end
  end
end