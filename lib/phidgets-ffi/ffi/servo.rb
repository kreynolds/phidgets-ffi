module Phidgets
  module FFI
    ServoType = enum(
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

    attach_function :CPhidgetServo_create, [:phid], :int 
    attach_function :CPhidgetServo_getMotorCount, [:phid, :pointer], :int 
    attach_function :CPhidgetServo_getPosition, [:phid, :int, :pointer], :int 
    attach_function :CPhidgetServo_setPosition, [:phid, :int, :double], :int 
    attach_function :CPhidgetServo_getPositionMax, [:phid, :int, :pointer], :int 
    attach_function :CPhidgetServo_getPositionMin, [:phid, :int, :pointer], :int 
	attach_function :CPhidgetServo_getEngaged, [:phid, :int, :pointer], :int
    attach_function :CPhidgetServo_setEngaged, [:phid, :int, :int], :int
    attach_function :CPhidgetServo_getServoType, [:phid, :int, :pointer], :int 
    attach_function :CPhidgetServo_setServoType, [:phid, :int, ServoType], :int 
    attach_function :CPhidgetServo_setServoParameters, [:phid, :int, :double, :double, :double], :int 

	callback :CPhidgetServo_set_OnPositionChange_Callback, [:phid, :user_ptr, :int, :double], :int
    attach_function :CPhidgetServo_set_OnPositionChange_Handler, [:phid, :CPhidgetServo_set_OnPositionChange_Callback, :user_ptr], :int 
	
    module CPhidgetServo
      def self.method_missing(method, *args, &block)
        if ::Phidgets::FFI.respond_to?("CPhidgetServo_#{method}".to_sym)
          if (rs = ::Phidgets::FFI.send("CPhidgetServo_#{method}".to_sym, *args, &block)) != 0
            raise Phidgets::Error.exception_for(rs), Phidgets::FFI.error_description(rs)
          end
        else
          super(method, *args, &block)
        end
      end
    end
  end
end
