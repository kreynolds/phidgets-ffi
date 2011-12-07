module Phidgets
  module FFI
 
	attach_function :CPhidgetSpatial_create, [:phid], :int 
    attach_function :CPhidgetSpatial_getAccelerationAxisCount, [:phid, :pointer], :int
	attach_function :CPhidgetSpatial_getGyroAxisCount, [:phid, :pointer], :int 
	attach_function :CPhidgetSpatial_getCompassAxisCount, [:phid, :pointer], :int
	attach_function :CPhidgetSpatial_getAcceleration, [:phid, :int, :pointer], :int
	attach_function :CPhidgetSpatial_getAccelerationMax, [:phid, :int, :pointer], :int
	attach_function :CPhidgetSpatial_getAccelerationMin, [:phid, :int, :pointer], :int
	attach_function :CPhidgetSpatial_getAngularRate, [:phid, :int, :pointer], :int 
	attach_function :CPhidgetSpatial_getAngularRateMax, [:phid, :int, :pointer], :int
	attach_function :CPhidgetSpatial_getAngularRateMin, [:phid, :int, :pointer], :int
	attach_function :CPhidgetSpatial_getMagneticField, [:phid, :int, :pointer], :int 
	attach_function :CPhidgetSpatial_getMagneticFieldMax, [:phid, :int, :pointer], :int
	attach_function :CPhidgetSpatial_getMagneticFieldMin, [:phid, :int, :pointer], :int
	attach_function :CPhidgetSpatial_zeroGyro, [:phid], :int 
    attach_function :CPhidgetSpatial_getDataRate, [:phid, :pointer], :int 
	attach_function :CPhidgetSpatial_setDataRate, [:phid, :int], :int 
	attach_function :CPhidgetSpatial_getDataRateMax, [:phid, :pointer], :int 
	attach_function :CPhidgetSpatial_getDataRateMin, [:phid, :pointer], :int 
    attach_function :CPhidgetSpatial_setCompassCorrectionParameters, [:phid, :double, :double, :double, :double, :double, :double, :double, :double, :double, :double, :double, :double, :double], :int 
    attach_function :CPhidgetSpatial_resetCompassCorrectionParameters, [:phid], :int

    callback :CPhidgetSpatial_set_OnSpatialData_Callback, [:phid, :user_ptr, :pointer, :int], :int
    attach_function :CPhidgetSpatial_set_OnSpatialData_Handler, [:phid, :CPhidgetSpatial_set_OnSpatialData_Callback, :user_ptr], :int 

    module CPhidgetSpatial
      def self.method_missing(method, *args, &block)
        if ::Phidgets::FFI.respond_to?("CPhidgetSpatial_#{method}".to_sym)
          if (rs = ::Phidgets::FFI.send("CPhidgetSpatial_#{method}".to_sym, *args, &block)) != 0
            raise Phidgets::Error.exception_for(rs), Phidgets::FFI.error_description(rs)
          end
        else
          super(method, *args, &block)
        end
      end
    end
  end
end