module Phidgets
  module FFI
    
	attach_function :CPhidgetMotorControl_create, [:phid], :int 
    attach_function :CPhidgetMotorControl_getMotorCount, [:phid, :pointer], :int 
	attach_function :CPhidgetMotorControl_getInputCount, [:phid, :pointer], :int 
	attach_function :CPhidgetMotorControl_getEncoderCount, [:phid, :pointer], :int 
	attach_function :CPhidgetMotorControl_getSensorCount, [:phid, :pointer], :int 
	attach_function :CPhidgetMotorControl_getVelocity, [:phid, :int, :pointer], :int 
    attach_function :CPhidgetMotorControl_setVelocity, [:phid, :int, :double], :int
    attach_function :CPhidgetMotorControl_getAcceleration, [:phid, :int, :pointer], :int 
    attach_function :CPhidgetMotorControl_setAcceleration, [:phid, :int, :double], :int	
	attach_function :CPhidgetMotorControl_getAccelerationMax, [:phid, :int, :pointer], :int
	attach_function :CPhidgetMotorControl_getAccelerationMin, [:phid, :int, :pointer], :int	
	attach_function :CPhidgetMotorControl_getCurrent, [:phid, :int, :pointer], :int
	attach_function :CPhidgetMotorControl_getInputState, [:phid, :int, :pointer], :int
	attach_function :CPhidgetMotorControl_getEncoderPosition, [:phid, :int, :pointer], :int 
    attach_function :CPhidgetMotorControl_setEncoderPosition, [:phid, :int, :int], :int	
	attach_function :CPhidgetMotorControl_getBackEMFSensingState, [:phid, :int, :pointer], :int
    attach_function :CPhidgetMotorControl_setBackEMFSensingState, [:phid, :int, :int], :int 
	attach_function :CPhidgetMotorControl_getBackEMF, [:phid, :int, :pointer], :int
	attach_function :CPhidgetMotorControl_getSupplyVoltage, [:phid, :pointer], :int
	attach_function :CPhidgetMotorControl_getBraking, [:phid, :int, :pointer], :int
	attach_function :CPhidgetMotorControl_setBraking, [:phid, :int, :double], :int
	attach_function :CPhidgetMotorControl_getSensorValue, [:phid, :int, :pointer], :int
	attach_function :CPhidgetMotorControl_getSensorRawValue, [:phid, :int, :pointer], :int
	attach_function :CPhidgetMotorControl_getRatiometric, [:phid, :pointer], :int
    attach_function :CPhidgetMotorControl_setRatiometric, [:phid, :int], :int 
		
	callback :CPhidgetMotorControl_set_OnVelocityChange_Callback, [:phid, :user_ptr, :int, :double], :int
    attach_function :CPhidgetMotorControl_set_OnVelocityChange_Handler, [:phid, :CPhidgetMotorControl_set_OnVelocityChange_Callback, :user_ptr], :int 
	
	callback :CPhidgetMotorControl_set_OnCurrentChange_Callback, [:phid, :user_ptr, :int, :double], :int
    attach_function :CPhidgetMotorControl_set_OnCurrentChange_Handler, [:phid, :CPhidgetMotorControl_set_OnCurrentChange_Callback, :user_ptr], :int

    callback :CPhidgetMotorControl_set_OnInputChange_Callback, [:phid, :user_ptr, :int, :int], :int
    attach_function :CPhidgetMotorControl_set_OnInputChange_Handler, [:phid, :CPhidgetMotorControl_set_OnInputChange_Callback, :user_ptr], :int 
    
	callback :CPhidgetMotorControl_set_OnEncoderPositionChange_Callback, [:phid, :user_ptr, :int, :int, :int], :int
    attach_function :CPhidgetMotorControl_set_OnEncoderPositionChange_Handler, [:phid, :CPhidgetMotorControl_set_OnEncoderPositionChange_Callback, :user_ptr], :int
	
	callback :CPhidgetMotorControl_set_OnEncoderPositionUpdate_Callback, [:phid, :user_ptr, :int, :int], :int
    attach_function :CPhidgetMotorControl_set_OnEncoderPositionUpdate_Handler, [:phid, :CPhidgetMotorControl_set_OnEncoderPositionUpdate_Callback, :user_ptr], :int
	
	callback :CPhidgetMotorControl_set_OnBackEMFUpdate_Callback, [:phid, :user_ptr, :int, :double], :int
    attach_function :CPhidgetMotorControl_set_OnBackEMFUpdate_Handler, [:phid, :CPhidgetMotorControl_set_OnBackEMFUpdate_Callback, :user_ptr], :int	
	
	callback :CPhidgetMotorControl_set_OnSensorUpdate_Callback, [:phid, :user_ptr, :int, :int], :int
    attach_function :CPhidgetMotorControl_set_OnSensorUpdate_Handler, [:phid, :CPhidgetMotorControl_set_OnSensorUpdate_Callback, :user_ptr], :int
	
	callback :CPhidgetMotorControl_set_OnCurrentUpdate_Callback, [:phid, :user_ptr, :int, :double], :int
    attach_function :CPhidgetMotorControl_set_OnCurrentUpdate_Handler, [:phid, :CPhidgetMotorControl_set_OnCurrentUpdate_Callback, :user_ptr], :int
	
    module CPhidgetMotorControl
      def self.method_missing(method, *args, &block)
        if ::Phidgets::FFI.respond_to?("CPhidgetMotorControl_#{method}".to_sym)
          if (rs = ::Phidgets::FFI.send("CPhidgetMotorControl_#{method}".to_sym, *args, &block)) != 0
            raise Phidgets::Error.exception_for(rs), Phidgets::FFI.error_description(rs)
          end
        else
          super(method, *args, &block)
        end
      end
    end
  end
end