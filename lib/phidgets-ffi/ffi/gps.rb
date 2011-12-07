module Phidgets
  module FFI
    attach_function :CPhidgetGPS_create, [:phid], :int 
 
    attach_function :CPhidgetGPS_getLatitude, [:phid, :pointer], :int 
    attach_function :CPhidgetGPS_getLongitude, [:phid, :pointer], :int 
    attach_function :CPhidgetGPS_getAltitude, [:phid, :pointer], :int 
    attach_function :CPhidgetGPS_getHeading, [:phid, :pointer], :int 
    attach_function :CPhidgetGPS_getVelocity, [:phid, :pointer], :int 
	attach_function :CPhidgetGPS_getTime, [:phid, :pointer], :int 
	attach_function :CPhidgetGPS_getDate, [:phid, :pointer], :int 
	attach_function :CPhidgetGPS_getPositionFixStatus, [:phid, :pointer], :int 
	   
    callback :CPhidgetGPS_set_OnPositionFixStatusChange_Callback, [:phid, :user_ptr, :int], :int
    attach_function :CPhidgetGPS_set_OnPositionFixStatusChange_Handler, [:phid, :CPhidgetGPS_set_OnPositionFixStatusChange_Callback, :user_ptr], :int 
 
	callback :CPhidgetGPS_set_OnPositionChange_Callback, [:phid, :user_ptr, :double, :double, :double], :int
    attach_function :CPhidgetGPS_set_OnPositionChange_Handler, [:phid, :CPhidgetGPS_set_OnPositionChange_Callback, :user_ptr], :int 
 
 module CPhidgetGPS
      def self.method_missing(method, *args, &block)
        if ::Phidgets::FFI.respond_to?("CPhidgetGPS_#{method}".to_sym)
          if (rs = ::Phidgets::FFI.send("CPhidgetGPS_#{method}".to_sym, *args, &block)) != 0
            raise Phidgets::Error.exception_for(rs), Phidgets::FFI.error_description(rs)
          end
        else
          super(method, *args, &block)
        end
      end
    end
  end
end