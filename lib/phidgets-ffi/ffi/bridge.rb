module Phidgets
  module FFI

   BridgeGains = enum(
      :gain_1, 1,
      :gain_8,
      :gain_16,
      :gain_32,
      :gain_64,
      :gain_128,
      :gain_unknown
    )

	attach_function :CPhidgetBridge_create, [:phid], :int
    attach_function :CPhidgetBridge_getInputCount, [:phid, :pointer], :int 
    attach_function :CPhidgetBridge_getBridgeValue, [:phid, :int, :pointer], :int 
    attach_function :CPhidgetBridge_getBridgeMax, [:phid, :int, :pointer], :int 
    attach_function :CPhidgetBridge_getBridgeMin, [:phid, :int, :pointer], :int 
    attach_function :CPhidgetBridge_setEnabled, [:phid, :int, :int], :int 
    attach_function :CPhidgetBridge_getEnabled, [:phid, :int, :pointer], :int 
    attach_function :CPhidgetBridge_getGain, [:phid, :int, :pointer], :int 
    attach_function :CPhidgetBridge_setGain, [:phid, :int, BridgeGains], :int 
    attach_function :CPhidgetBridge_getDataRate, [:phid, :pointer], :int 
    attach_function :CPhidgetBridge_setDataRate, [:phid, :int], :int 
    attach_function :CPhidgetBridge_getDataRateMax, [:phid, :pointer], :int 
    attach_function :CPhidgetBridge_getDataRateMin, [:phid, :pointer], :int 
    attach_function :CPhidgetBridge_getBridgeValue, [:phid, :int, :pointer], :int 

    callback :CPhidgetBridge_set_OnBridgeData_Callback, [:phid, :user_ptr, :int, :double], :int
    attach_function :CPhidgetBridge_set_OnBridgeData_Handler, [:phid, :CPhidgetBridge_set_OnBridgeData_Callback, :user_ptr], :int 
 
module CPhidgetBridge
      def self.method_missing(method, *args, &block)
        if ::Phidgets::FFI.respond_to?("CPhidgetBridge_#{method}".to_sym)
          if (rs = ::Phidgets::FFI.send("CPhidgetBridge_#{method}".to_sym, *args, &block)) != 0
            raise Phidgets::Error.exception_for(rs), Phidgets::FFI.error_description(rs)
          end
        else
          super(method, *args, &block)
        end
      end
    end
  end
end