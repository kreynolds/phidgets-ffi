module Phidgets
  module FFI
  
    attach_function :CPhidgetAccelerometer_create, [:phid], :int
	attach_function :CPhidgetAccelerometer_getAxisCount, [:phid, :pointer], :int 
 	attach_function :CPhidgetAccelerometer_getAcceleration, [:phid, :int, :pointer], :int 
	attach_function :CPhidgetAccelerometer_getAccelerationMax, [:phid, :int, :pointer], :int 
	attach_function :CPhidgetAccelerometer_getAccelerationMin, [:phid, :int, :pointer], :int     
	attach_function :CPhidgetAccelerometer_getAccelerationChangeTrigger, [:phid, :int, :pointer], :int 
	attach_function :CPhidgetAccelerometer_setAccelerationChangeTrigger, [:phid, :int, :double], :int 
	
    callback :CPhidgetAccelerometer_set_OnAccelerationChange_Callback, [:phid, :user_ptr, :int, :double], :int	
	attach_function :CPhidgetAccelerometer_set_OnAccelerationChange_Handler, [:phid, :CPhidgetAccelerometer_set_OnAccelerationChange_Callback, :user_ptr], :int

    module CPhidgetAccelerometer
      def self.method_missing(method, *args, &block)
        if ::Phidgets::FFI.respond_to?("CPhidgetAccelerometer_#{method}".to_sym)
          if (rs = ::Phidgets::FFI.send("CPhidgetAccelerometer_#{method}".to_sym, *args, &block)) != 0
            raise Phidgets::Error.exception_for(rs), Phidgets::FFI.error_description(rs)
          end
        else
          super(method, *args, &block)
        end
      end
    end
  end
end



