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
      :user_defind
    )

    attach_function :CPhidgetServo_create, [:phid], :int #int CPhidgetServo_create(CPhidgetServoHandle *phid);
    attach_function :CPhidgetServo_getMotorCount, [:phid, :pointer], :int # int CPhidgetServo_getMotorCount(CPhidgetServoHandle phid, int *count);
    attach_function :CPhidgetServo_getPosition, [:phid, :int, :pointer], :int #int CPhidgetServo_getPosition(CPhidgetServoHandle phid, int index, double *position);
    attach_function :CPhidgetServo_setPosition, [:phid, :int, :double], :int #int CPhidgetServo_setPosition(CPhidgetServoHandle phid, int index, double position);
    attach_function :CPhidgetServo_getPositionMax, [:phid, :int, :pointer], :int #int CPhidgetServo_getPositionMax(CPhidgetServoHandle phid, int index, double *max);
    attach_function :CPhidgetServo_getPositionMin, [:phid, :int, :pointer], :int #int CPhidgetServo_getPositionMin(CPhidgetServoHandle phid, int index, double *min);
    callback :CPhidgetServo_set_OnPositionChange_Callback, [:phid, :user_ptr, :int, :double], :int
    attach_function :CPhidgetServo_set_OnPositionChange_Handler, [:phid, :CPhidgetServo_set_OnPositionChange_Callback, :user_ptr], :int #int CPhidgetServo_set_OnPositionChange_Handler(CPhidgetServoHandle phid, int ( *fptr)(CPhidgetServoHandle phid, void *userPtr, int index, double position), void *userPtr);
    attach_function :CPhidgetServo_getEngaged, [:phid, :int, :pointer], :int #int CPhidgetServo_getEngaged(CPhidgetServoHandle phid, int index, int *engagedState);
    attach_function :CPhidgetServo_setEngaged, [:phid, :int, :int], :int #int CPhidgetServo_setEngaged(CPhidgetServoHandle phid, int index, int engagedState);
    attach_function :CPhidgetServo_getServoType, [:phid, :int, :pointer], :int #int CPhidgetServo_getServoType(CPhidgetServoHandle phid, int index, CPhidget_ServoType *servoType);
    attach_function :CPhidgetServo_setServoType, [:phid, :int, ServoType], :int #int CPhidgetServo_setServoType(CPhidgetServoHandle phid, int index, CPhidget_ServoType servoType);
    attach_function :CPhidgetServo_setServoParameters, [:phid, :int, :double, :double, :double], :int #int CPhidgetServo_setServoParameters(CPhidgetServoHandle phid, int index, double min_us,double max_us,double degrees);
  end
end