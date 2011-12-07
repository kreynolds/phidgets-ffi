module Phidgets
  module FFI
    
	AdvancedServoType = enum(
      :default, 1,
      :raw_us_mode,
      :hitec_hs322hd,
      :hitec_hS5245mg,
      :hitec_805bb,
      :hitec_hs422,
      :towerpro_mg90,
      :hitec_hsr1425cr,
      :hitec_hs785hb,
      :hitec_hs485hb,
      :hitec_hs645mg,
      :hitec_815bb,
      :firgelli_l12_30_50_06_r,
      :firgelli_l12_50_100_06_r,
      :firgelli_l12_50_210_06_r,
      :firgelli_l12_100_50_06_r,
      :firgelli_l12_100_100_06_r,
      :user_defined
    )

	attach_function :CPhidgetAdvancedServo_create, [:phid], :int 
    attach_function :CPhidgetAdvancedServo_getMotorCount, [:phid, :pointer], :int 
    attach_function :CPhidgetAdvancedServo_getAcceleration, [:phid, :int, :pointer], :int 
    attach_function :CPhidgetAdvancedServo_setAcceleration, [:phid, :int, :double], :int 
    attach_function :CPhidgetAdvancedServo_getAccelerationMax, [:phid, :int, :pointer], :int 
    attach_function :CPhidgetAdvancedServo_getAccelerationMin, [:phid, :int, :pointer], :int 
    attach_function :CPhidgetAdvancedServo_getVelocityLimit, [:phid, :int, :pointer], :int 
	attach_function :CPhidgetAdvancedServo_setVelocityLimit, [:phid, :int, :double], :int 
	attach_function :CPhidgetAdvancedServo_getVelocity, [:phid, :int, :pointer], :int 
	attach_function :CPhidgetAdvancedServo_getVelocityMax, [:phid, :int, :pointer], :int 
	attach_function :CPhidgetAdvancedServo_getVelocityMin, [:phid, :int, :pointer], :int 
	attach_function :CPhidgetAdvancedServo_getPosition, [:phid, :int, :pointer], :int 
	attach_function :CPhidgetAdvancedServo_setPosition, [:phid, :int, :double], :int 
	attach_function :CPhidgetAdvancedServo_getPositionMax, [:phid, :int, :pointer], :int 
	attach_function :CPhidgetAdvancedServo_setPositionMax, [:phid, :int, :double], :int 
	attach_function :CPhidgetAdvancedServo_getPositionMin, [:phid, :int, :pointer], :int 
	attach_function :CPhidgetAdvancedServo_setPositionMin, [:phid, :int, :double], :int 
	attach_function :CPhidgetAdvancedServo_getCurrent, [:phid, :int, :pointer], :int 
	attach_function :CPhidgetAdvancedServo_getSpeedRampingOn, [:phid, :int, :pointer], :int 
	attach_function :CPhidgetAdvancedServo_setSpeedRampingOn, [:phid, :int, :int], :int 
	attach_function :CPhidgetAdvancedServo_getEngaged, [:phid, :int, :pointer], :int 
	attach_function :CPhidgetAdvancedServo_setEngaged, [:phid, :int, :int], :int 
	attach_function :CPhidgetAdvancedServo_getStopped, [:phid, :int, :pointer], :int 
	attach_function :CPhidgetAdvancedServo_getServoType, [:phid, :int, :pointer], :int  
	attach_function :CPhidgetAdvancedServo_setServoType, [:phid, :int, AdvancedServoType], :int  
	attach_function :CPhidgetAdvancedServo_setServoParameters, [:phid, :int, :double, :double, :double, :double], :int  
	
	callback :CPhidgetAdvancedServo_set_OnVelocityChange_Callback, [:phid, :user_ptr, :int, :double], :int
    attach_function :CPhidgetAdvancedServo_set_OnVelocityChange_Handler, [:phid, :CPhidgetAdvancedServo_set_OnVelocityChange_Callback, :user_ptr], :int
	
	callback :CPhidgetAdvancedServo_set_OnPositionChange_Callback, [:phid, :user_ptr, :int, :double], :int
    attach_function :CPhidgetAdvancedServo_set_OnPositionChange_Handler, [:phid, :CPhidgetAdvancedServo_set_OnPositionChange_Callback, :user_ptr], :int 
	
	callback :CPhidgetAdvancedServo_set_OnCurrentChange_Callback, [:phid, :user_ptr, :int, :double], :int
    attach_function :CPhidgetAdvancedServo_set_OnCurrentChange_Handler, [:phid, :CPhidgetAdvancedServo_set_OnCurrentChange_Callback, :user_ptr], :int 
	
    module CPhidgetAdvancedServo
      def self.method_missing(method, *args, &block)
        if ::Phidgets::FFI.respond_to?("CPhidgetAdvancedServo_#{method}".to_sym)
          if (rs = ::Phidgets::FFI.send("CPhidgetAdvancedServo_#{method}".to_sym, *args, &block)) != 0
            raise Phidgets::Error.exception_for(rs), Phidgets::FFI.error_description(rs)
          end
        else
          super(method, *args, &block)
        end
      end
    end
  end
end