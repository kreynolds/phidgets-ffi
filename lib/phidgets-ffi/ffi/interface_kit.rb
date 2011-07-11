module Phidgets
  module FFI
    attach_function :CPhidgetInterfaceKit_create, [:phid], :int #int CPhidgetInterfaceKit_create(CPhidgetInterfaceKitHandle *phid);
    attach_function :CPhidgetInterfaceKit_getInputCount, [:phid, :pointer], :int #int CPhidgetInterfaceKit_getInputCount(CPhidgetInterfaceKitHandle phid, int *count);
    attach_function :CPhidgetInterfaceKit_getInputState, [:phid, :int, :pointer], :int #int CPhidgetInterfaceKit_getInputState(CPhidgetInterfaceKitHandle phid, int index, int *inputState);
    callback :CPhidgetInterfaceKit_set_OnInputChange_Callback, [:phid, :user_ptr, :int, :int], :int
    attach_function :CPhidgetInterfaceKit_set_OnInputChange_Handler, [:phid, :CPhidgetInterfaceKit_set_OnInputChange_Callback, :user_ptr], :int #int CPhidgetInterfaceKit_set_OnInputChange_Handler(CPhidgetInterfaceKitHandle phid, int ( *fptr)(CPhidgetInterfaceKitHandle phid, void *userPtr, int index, int inputState), void *userPtr);
    attach_function :CPhidgetInterfaceKit_getOutputCount, [:phid, :pointer], :int #int CPhidgetInterfaceKit_getOutputCount(CPhidgetInterfaceKitHandle phid, int *count);
    attach_function :CPhidgetInterfaceKit_getOutputState, [:phid, :int, :pointer], :int #int CPhidgetInterfaceKit_getOutputState(CPhidgetInterfaceKitHandle phid, int index, int *outputState);
    attach_function :CPhidgetInterfaceKit_setOutputState, [:phid, :int, :int], :int #int CPhidgetInterfaceKit_setOutputState(CPhidgetInterfaceKitHandle phid, int index, int outputState);
    callback :CPhidgetInterfaceKit_set_OnOutputChange_Callback, [:phid, :user_ptr, :int, :int], :int
    attach_function :CPhidgetInterfaceKit_set_OnOutputChange_Handler, [:phid, :CPhidgetInterfaceKit_set_OnOutputChange_Callback, :user_ptr], :int #int CPhidgetInterfaceKit_set_OnOutputChange_Handler(CPhidgetInterfaceKitHandle phid, int ( *fptr)(CPhidgetInterfaceKitHandle phid, void *userPtr, int index, int outputState), void *userPtr);
    attach_function :CPhidgetInterfaceKit_getSensorCount, [:phid, :pointer], :int #int CPhidgetInterfaceKit_getSensorCount(CPhidgetInterfaceKitHandle phid, int *count);
    attach_function :CPhidgetInterfaceKit_getSensorValue, [:phid, :int, :pointer], :int #int CPhidgetInterfaceKit_getSensorValue(CPhidgetInterfaceKitHandle phid, int index, int *sensorValue);
    attach_function :CPhidgetInterfaceKit_getSensorRawValue, [:phid, :int, :pointer], :int #int CPhidgetInterfaceKit_getSensorRawValue(CPhidgetInterfaceKitHandle phid, int index, int *sensorRawValue);
    callback :CPhidgetInterfaceKit_set_OnSensorChange_Callback, [:phid, :user_ptr, :int, :int], :int
    attach_function :CPhidgetInterfaceKit_set_OnSensorChange_Handler, [:phid, :CPhidgetInterfaceKit_set_OnSensorChange_Callback, :user_ptr], :int #int CPhidgetInterfaceKit_set_OnSensorChange_Handler(CPhidgetInterfaceKitHandle phid, int ( *fptr)(CPhidgetInterfaceKitHandle phid, void *userPtr, int index, int sensorValue), void *userPtr);
    attach_function :CPhidgetInterfaceKit_getSensorChangeTrigger, [:phid, :int, :pointer], :int #int CPhidgetInterfaceKit_getSensorChangeTrigger(CPhidgetInterfaceKitHandle phid, int index, int *trigger);
    attach_function :CPhidgetInterfaceKit_setSensorChangeTrigger, [:phid, :int, :int], :int #int CPhidgetInterfaceKit_setSensorChangeTrigger(CPhidgetInterfaceKitHandle phid, int index, int trigger);
    attach_function :CPhidgetInterfaceKit_getRatiometric, [:phid, :pointer], :int #int CPhidgetInterfaceKit_getRatiometric(CPhidgetInterfaceKitHandle phid, int *ratiometric);
    attach_function :CPhidgetInterfaceKit_setRatiometric, [:phid, :int], :int #int CPhidgetInterfaceKit_setRatiometric(CPhidgetInterfaceKitHandle phid, int ratiometric);
    attach_function :CPhidgetInterfaceKit_getDataRate, [:phid, :int, :pointer], :int #int CPhidgetInterfaceKit_getDataRate(CPhidgetInterfaceKitHandle phid, int index, int *milliseconds);
    attach_function :CPhidgetInterfaceKit_setDataRate, [:phid, :int, :int], :int #int CPhidgetInterfaceKit_setDataRate(CPhidgetInterfaceKitHandle phid, int index, int milliseconds);
    attach_function :CPhidgetInterfaceKit_getDataRateMax, [:phid, :int, :pointer], :int #int CPhidgetInterfaceKit_getDataRateMax(CPhidgetInterfaceKitHandle phid, int index, int *max);
    attach_function :CPhidgetInterfaceKit_getDataRateMin, [:phid, :int, :pointer], :int #int CPhidgetInterfaceKit_getDataRateMin(CPhidgetInterfaceKitHandle phid, int index, int *min);

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