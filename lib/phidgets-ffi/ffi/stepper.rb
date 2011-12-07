module Phidgets
  module FFI
    
	attach_function :CPhidgetStepper_create, [:phid], :int 
	attach_function :CPhidgetStepper_getInputCount, [:phid, :pointer], :int
    attach_function :CPhidgetStepper_getInputState, [:phid, :int, :pointer], :int 
    attach_function :CPhidgetStepper_getMotorCount, [:phid, :pointer], :int
    attach_function :CPhidgetStepper_getAcceleration, [:phid, :int, :pointer], :int 
    attach_function :CPhidgetStepper_setAcceleration, [:phid, :int, :double], :int 
	attach_function :CPhidgetStepper_getAccelerationMax, [:phid, :int, :pointer], :int 
	attach_function :CPhidgetStepper_getAccelerationMin, [:phid, :int, :pointer], :int 
    attach_function :CPhidgetStepper_getVelocityLimit, [:phid, :int, :pointer], :int 
    attach_function :CPhidgetStepper_setVelocityLimit, [:phid, :int, :double], :int 	
	attach_function :CPhidgetStepper_getVelocity, [:phid, :int, :pointer], :int 
	attach_function :CPhidgetStepper_getVelocityMax, [:phid, :int, :pointer], :int 
	attach_function :CPhidgetStepper_getVelocityMin, [:phid, :int, :pointer], :int 
	attach_function :CPhidgetStepper_getTargetPosition, [:phid, :int, :pointer], :int 
    attach_function :CPhidgetStepper_setTargetPosition, [:phid, :int, :long_long], :int
	attach_function :CPhidgetStepper_getCurrentPosition, [:phid, :int, :pointer], :int 
    attach_function :CPhidgetStepper_setCurrentPosition, [:phid, :int, :long_long], :int	
    attach_function :CPhidgetStepper_getPositionMax, [:phid, :int, :long_long], :int	
    attach_function :CPhidgetStepper_getPositionMin, [:phid, :int, :long_long], :int		
	attach_function :CPhidgetStepper_getCurrentLimit, [:phid, :int, :pointer], :int 
    attach_function :CPhidgetStepper_setCurrentLimit, [:phid, :int, :double], :int 	
    attach_function :CPhidgetStepper_getCurrent, [:phid, :int, :pointer], :int 	
	attach_function :CPhidgetStepper_getCurrentMax, [:phid, :int, :pointer], :int 	
	attach_function :CPhidgetStepper_getCurrentMin, [:phid, :int, :pointer], :int 	
	attach_function :CPhidgetStepper_getEngaged, [:phid, :int, :pointer], :int 
    attach_function :CPhidgetStepper_setEngaged, [:phid, :int, :int], :int 	
	attach_function :CPhidgetStepper_getStopped, [:phid, :int, :pointer], :int 

    callback :CPhidgetStepper_set_OnInputChange_Callback, [:phid, :user_ptr, :int, :int], :int
    attach_function :CPhidgetStepper_set_OnInputChange_Handler, [:phid, :CPhidgetStepper_set_OnInputChange_Callback, :user_ptr], :int

    callback :CPhidgetStepper_set_OnVelocityChange_Callback, [:phid, :user_ptr, :int, :double], :int
    attach_function :CPhidgetStepper_set_OnVelocityChange_Handler, [:phid, :CPhidgetStepper_set_OnVelocityChange_Callback, :user_ptr], :int

    callback :CPhidgetStepper_set_OnPositionChange_Callback, [:phid, :user_ptr, :int, :long_long], :int
    attach_function :CPhidgetStepper_set_OnPositionChange_Handler, [:phid, :CPhidgetStepper_set_OnPositionChange_Callback, :user_ptr], :int

    callback :CPhidgetStepper_set_OnCurrentChange_Callback, [:phid, :user_ptr, :int, :double], :int
    attach_function :CPhidgetStepper_set_OnCurrentChange_Handler, [:phid, :CPhidgetStepper_set_OnCurrentChange_Callback, :user_ptr], :int
	
    module CPhidgetStepper
      def self.method_missing(method, *args, &block)
        if ::Phidgets::FFI.respond_to?("CPhidgetStepper_#{method}".to_sym)
          if (rs = ::Phidgets::FFI.send("CPhidgetStepper_#{method}".to_sym, *args, &block)) != 0
            raise Phidgets::Error.exception_for(rs), Phidgets::FFI.error_description(rs)
          end
        else
          super(method, *args, &block)
        end
      end
    end
  end
end