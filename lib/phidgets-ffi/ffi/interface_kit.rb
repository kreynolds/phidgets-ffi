module Phidgets
  module FFI
    attach_function :CPhidgetInterfaceKit_create, [:phid], :int 
    attach_function :CPhidgetInterfaceKit_getInputCount, [:phid, :pointer], :int 
    attach_function :CPhidgetInterfaceKit_getInputState, [:phid, :int, :pointer], :int
    attach_function :CPhidgetInterfaceKit_getOutputCount, [:phid, :pointer], :int 
    attach_function :CPhidgetInterfaceKit_getOutputState, [:phid, :int, :pointer], :int 
    attach_function :CPhidgetInterfaceKit_setOutputState, [:phid, :int, :int], :int
    attach_function :CPhidgetInterfaceKit_getSensorCount, [:phid, :pointer], :int 
    attach_function :CPhidgetInterfaceKit_getSensorValue, [:phid, :int, :pointer], :int 
    attach_function :CPhidgetInterfaceKit_getSensorRawValue, [:phid, :int, :pointer], :int 
	attach_function :CPhidgetInterfaceKit_getSensorChangeTrigger, [:phid, :int, :pointer], :int 
    attach_function :CPhidgetInterfaceKit_setSensorChangeTrigger, [:phid, :int, :int], :int
    attach_function :CPhidgetInterfaceKit_getRatiometric, [:phid, :pointer], :int
    attach_function :CPhidgetInterfaceKit_setRatiometric, [:phid, :int], :int 
    attach_function :CPhidgetInterfaceKit_getDataRate, [:phid, :int, :pointer], :int
    attach_function :CPhidgetInterfaceKit_setDataRate, [:phid, :int, :int], :int 
    attach_function :CPhidgetInterfaceKit_getDataRateMax, [:phid, :int, :pointer], :int 
    attach_function :CPhidgetInterfaceKit_getDataRateMin, [:phid, :int, :pointer], :int 

	callback :CPhidgetInterfaceKit_set_OnInputChange_Callback, [:phid, :user_ptr, :int, :int], :int
    attach_function :CPhidgetInterfaceKit_set_OnInputChange_Handler, [:phid, :CPhidgetInterfaceKit_set_OnInputChange_Callback, :user_ptr], :int 
	
	callback :CPhidgetInterfaceKit_set_OnSensorChange_Callback, [:phid, :user_ptr, :int, :int], :int
    attach_function :CPhidgetInterfaceKit_set_OnSensorChange_Handler, [:phid, :CPhidgetInterfaceKit_set_OnSensorChange_Callback, :user_ptr], :int
   
    callback :CPhidgetInterfaceKit_set_OnOutputChange_Callback, [:phid, :user_ptr, :int, :int], :int
    attach_function :CPhidgetInterfaceKit_set_OnOutputChange_Handler, [:phid, :CPhidgetInterfaceKit_set_OnOutputChange_Callback, :user_ptr], :int
	
    module CPhidgetInterfaceKit
      def self.method_missing(method, *args, &block)
        if ::Phidgets::FFI.respond_to?("CPhidgetInterfaceKit_#{method}".to_sym)
          if (rs = ::Phidgets::FFI.send("CPhidgetInterfaceKit_#{method}".to_sym, *args, &block)) != 0
            raise Phidgets::Error.exception_for(rs), Phidgets::FFI.error_description(rs)
          end
        else
          super(method, *args, &block)
        end
      end
    end
  end
end