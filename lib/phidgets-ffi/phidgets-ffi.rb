module PhidgetsFFI
  extend FFI::Library
  ffi_lib '/Library/Frameworks/Phidget21.framework/Versions/Current/Phidget21'

  typedef :pointer, :phid

  DeviceStatus = enum(
    :detached, 0,
    :attached, 1
  )
  DeviceClass = enum(
    :accelerometer, 2,
    :advanced_servo, 3,
    :encoder, 4,
    :analog, 22,
    :bridge, 23,
    :frequency_counter, 21,
    :gps, 5,
    :interface_kit, 7,
    :ir, 19,
    :led, 8,
    :motor_control, 9,
    :ph_sensor, 10,
    :rfid, 11,
    :servo, 12,
    :spatial, 20,
    :stepper, 13,
    :temperature_sensor, 14,
    :text_lcd, 15,
    :text_led, 16,
    :weight_sensor, 17
  )
  
  DeviceID = enum(
    :accelerometer_3axis, 0x07E,
    :advanced_servo_1motor, 0x082,
    :advanced_servo_8motor, 0x03A,
    :analog_4output, 0x037,
    :bipolar_stepper_1motor, 0x07B,
    :bridge_4input, 0x03B,
    :encoder_1encoder_1input, 0x04B,
    :encoder_hs_1encoder, 0x080,
    :encoder_hs_4encoder_4input, 0x04F,
    :frequency_counter_2input, 0x035,
    :gps, 0x079,
    :interface_kit_0_0_4, 0x040,
    :interface_kit_0_0_8, 0x081,
    :interface_kit_0_16_16, 0x044,
    :interface_kit_2_2_2, 0x036,
    :interface_kit_8_8_8, 0x045,
    :interface_kit_8_8_8_w_lcd, 0x07D,
    :ir, 0x04D,
    :led_64_adv, 0x04C,
    :linear_touch, 0x076,
    :motor_control_1motor, 0x03E,
    :motor_control_hc_2motor, 0x059,
    :rfid_2output, 0x031,
    :rotary_touch, 0x077,
    :spatial_accel_3axis, 0x07F,
    :spatial_accel_gyro_compass, 0x033,
    :temperature_sensor, 0x070,
    :temperature_sensor_4, 0x032,
    :sensor_ir, 0x03C,
    :textlcd_2x20_w_8_8_8, 0x17D,
    :textlcd_adapter, 0x03D,
    :unipolar_stepper_4motor, 0x07A,
    :accelerometer_2axis, 0x071,
    :interface_kit_0_8_8_w_lcd, 0x053,
    :interface_kit_4_8_8, 4,
    :led_64, 0x04A,
    :motorcontrol_LV_2motor_4input, 0x058,
    :ph_sensor, 0x074,
    :rfid, 0x030,
    :servo_1motor, 0x039,
    :servo_1motor_old, 2,
    :servo_4motor, 0x038,
    :servo_4motor_old, 3,
    :textlcd_2x20, 0x052,
    :textlcd_2x20_w_0_8_8, 0x153,
    :textled_1x8, 0x049,
    :textled_4x8, 0x048,
    :weight_sensor, 0x072
  )

  attach_function :CPhidget_open, [:phid, :int], :int #int CPhidget_open(CPhidgetHandle phid, int serialNumber);
  attach_function :CPhidget_openLabel, [:phid, :string], :int #int CPhidget_openLabel(CPhidgetHandle phid, const char *label);
  attach_function :CPhidget_close, [:phid], :int #int CPhidget_close(CPhidgetHandle phid);
  attach_function :CPhidget_delete, [:phid], :int #int CPhidget_delete(CPhidgetHandle phid);
  callback :CPhidget_set_OnDetach_Callback, [:phid, :pointer], :int
  attach_function :CPhidget_set_OnDetach_Handler, [:phid, :CPhidget_set_OnDetach_Callback, :pointer], :int #int CPhidget_set_OnDetach_Handler(CPhidgetHandle phid, int( *fptr)(CPhidgetHandle phid, void *userPtr), void *userPtr);
  callback :CPhidget_set_OnAttach_Callback, [:phid, :pointer], :int
  attach_function :CPhidget_set_OnAttach_Handler, [:phid, :CPhidget_set_OnAttach_Callback, :pointer], :int #int CPhidget_set_OnAttach_Handler(CPhidgetHandle phid, int( *fptr)(CPhidgetHandle phid, void *userPtr), void *userPtr);
  callback :CPhidget_set_OnServerConnect_Callback, [:phid, :pointer], :int
  attach_function :CPhidget_set_OnServerConnect_Handler, [:phid, :CPhidget_set_OnServerConnect_Callback, :pointer], :int #int CPhidget_set_OnServerConnect_Handler(CPhidgetHandle phid, int ( *fptr)(CPhidgetHandle phid, void *userPtr), void *userPtr);
  callback :CPhidget_set_OnServerDisconnect_Callback, [:phid, :pointer], :int
  attach_function :CPhidget_set_OnServerDisconnect_Handler, [:phid, :CPhidget_set_OnServerDisconnect_Callback, :pointer], :int #int CPhidget_set_OnServerDisconnect_Handler(CPhidgetHandle phid, int ( *fptr)(CPhidgetHandle phid, void *userPtr), void *userPtr);
  callback :CPhidget_set_OnError_Callback, [:phid, :pointer, :int, :string], :int
  attach_function :CPhidget_set_OnError_Handler, [:phid, :CPhidget_set_OnError_Callback, :pointer], :int #int CPhidget_set_OnError_Handler(CPhidgetHandle phid, int( *fptr)(CPhidgetHandle phid, void *userPtr, int errorCode, const char *errorString), void *userPtr);
  attach_function :CPhidget_getDeviceName, [:phid, :pointer], :int #int CPhidget_getDeviceName(CPhidgetHandle phid, const char **deviceName);
  attach_function :CPhidget_getSerialNumber, [:phid, :pointer], :int #int CPhidget_getSerialNumber(CPhidgetHandle phid, int *serialNumber);
  attach_function :CPhidget_getDeviceVersion, [:phid, :pointer], :int #int CPhidget_getDeviceVersion(CPhidgetHandle phid, int *deviceVersion);
  attach_function :CPhidget_getDeviceStatus, [:phid, :pointer], :int #int CPhidget_getDeviceStatus(CPhidgetHandle phid, int *deviceStatus);
  attach_function :CPhidget_getLibraryVersion, [:pointer], :int
  attach_function :CPhidget_getDeviceType, [:phid, :pointer], :int #int CPhidget_getDeviceType(CPhidgetHandle phid, const char **deviceType);
  attach_function :CPhidget_getDeviceLabel, [:phid, :pointer], :int #int CPhidget_getDeviceLabel(CPhidgetHandle phid, const char **deviceLabel);
  attach_function :CPhidget_setDeviceLabel, [:phid, :string], :int #int CPhidget_setDeviceLabel(CPhidgetHandle phid, const char *deviceLabel);
  attach_function :CPhidget_getErrorDescription, [:int, :pointer], :int #int CPhidget_getErrorDescription(int errorCode, const char **errorString);
  attach_function :CPhidget_waitForAttachment, [:phid, :int], :int
  attach_function :CPhidget_getServerID, [:phid, :pointer], :int #int CPhidget_getServerID(CPhidgetHandle phid, const char **serverID);
  attach_function :CPhidget_getServerAddress, [:phid, :pointer, :pointer], :int #int CPhidget_getServerAddress(CPhidgetHandle phid, const char **address, int *port);
  attach_function :CPhidget_getServerStatus, [:phid, :pointer], :int #int CPhidget_getServerStatus(CPhidgetHandle phid, int *serverStatus);
  attach_function :CPhidget_getDeviceID, [:phid, :pointer], :int #int CPhidget_getDeviceID(CPhidgetHandle phid, CPhidget_DeviceID *deviceID);
  attach_function :CPhidget_getDeviceClass, [:phid, :pointer], :int #int CPhidget_getDeviceClass(CPhidgetHandle phid, CPhidget_DeviceClass *deviceClass);
  callback :CPhidget_set_OnWillSleep_Callback, [:pointer], :int
  attach_function :CPhidget_set_OnWillSleep_Handler, [:CPhidget_set_OnWillSleep_Callback, :pointer], :int #int CPhidget_set_OnWillSleep_Handler(int( *fptr)(void *userPtr), void *userPtr);
  callback :CPhidget_set_OnWakeup_Callback, [:pointer], :int
  attach_function :CPhidget_set_OnWakeup_Handler, [:CPhidget_set_OnWakeup_Callback, :pointer], :int #int CPhidget_set_OnWakeup_Handler(int( *fptr)(void *userPtr), void *userPtr);

  attach_function :CPhidgetInterfaceKit_create, [:phid], :int #int CPhidgetInterfaceKit_create(CPhidgetInterfaceKitHandle *phid);
  attach_function :CPhidgetInterfaceKit_getInputCount, [:phid, :pointer], :int #int CPhidgetInterfaceKit_getInputCount(CPhidgetInterfaceKitHandle phid, int *count);
  attach_function :CPhidgetInterfaceKit_getInputState, [:phid, :int, :pointer], :int #int CPhidgetInterfaceKit_getInputState(CPhidgetInterfaceKitHandle phid, int index, int *inputState);
  callback :CPhidgetInterfaceKit_set_OnInputChange_Callback, [:phid, :pointer, :int, :int], :int
  attach_function :CPhidgetInterfaceKit_set_OnInputChange_Handler, [:phid, :CPhidgetInterfaceKit_set_OnInputChange_Callback, :pointer], :int #int CPhidgetInterfaceKit_set_OnInputChange_Handler(CPhidgetInterfaceKitHandle phid, int ( *fptr)(CPhidgetInterfaceKitHandle phid, void *userPtr, int index, int inputState), void *userPtr);
  attach_function :CPhidgetInterfaceKit_getOutputCount, [:phid, :pointer], :int #int CPhidgetInterfaceKit_getOutputCount(CPhidgetInterfaceKitHandle phid, int *count);
  attach_function :CPhidgetInterfaceKit_getOutputState, [:phid, :int, :pointer], :int #int CPhidgetInterfaceKit_getOutputState(CPhidgetInterfaceKitHandle phid, int index, int *outputState);
  attach_function :CPhidgetInterfaceKit_setOutputState, [:phid, :int, :int], :int #int CPhidgetInterfaceKit_setOutputState(CPhidgetInterfaceKitHandle phid, int index, int outputState);
  callback :CPhidgetInterfaceKit_set_OnOutputChange_Callback, [:phid, :pointer, :int, :int], :int
  attach_function :CPhidgetInterfaceKit_set_OnOutputChange_Handler, [:phid, :CPhidgetInterfaceKit_set_OnOutputChange_Callback, :pointer], :int #int CPhidgetInterfaceKit_set_OnOutputChange_Handler(CPhidgetInterfaceKitHandle phid, int ( *fptr)(CPhidgetInterfaceKitHandle phid, void *userPtr, int index, int outputState), void *userPtr);
  attach_function :CPhidgetInterfaceKit_getSensorCount, [:phid, :pointer], :int #int CPhidgetInterfaceKit_getSensorCount(CPhidgetInterfaceKitHandle phid, int *count);
  attach_function :CPhidgetInterfaceKit_getSensorValue, [:phid, :int, :pointer], :int #int CPhidgetInterfaceKit_getSensorValue(CPhidgetInterfaceKitHandle phid, int index, int *sensorValue);
  attach_function :CPhidgetInterfaceKit_getSensorRawValue, [:phid, :int, :pointer], :int #int CPhidgetInterfaceKit_getSensorRawValue(CPhidgetInterfaceKitHandle phid, int index, int *sensorRawValue);
  callback :CPhidgetInterfaceKit_set_OnSensorChange_Callback, [:phid, :pointer, :int, :int], :int
  attach_function :CPhidgetInterfaceKit_set_OnSensorChange_Handler, [:phid, :CPhidgetInterfaceKit_set_OnSensorChange_Callback, :pointer], :int #int CPhidgetInterfaceKit_set_OnSensorChange_Handler(CPhidgetInterfaceKitHandle phid, int ( *fptr)(CPhidgetInterfaceKitHandle phid, void *userPtr, int index, int sensorValue), void *userPtr);
  attach_function :CPhidgetInterfaceKit_getSensorChangeTrigger, [:phid, :int, :pointer], :int #int CPhidgetInterfaceKit_getSensorChangeTrigger(CPhidgetInterfaceKitHandle phid, int index, int *trigger);
  attach_function :CPhidgetInterfaceKit_setSensorChangeTrigger, [:phid, :int, :int], :int #int CPhidgetInterfaceKit_setSensorChangeTrigger(CPhidgetInterfaceKitHandle phid, int index, int trigger);
  attach_function :CPhidgetInterfaceKit_getRatiometric, [:phid, :pointer], :int #int CPhidgetInterfaceKit_getRatiometric(CPhidgetInterfaceKitHandle phid, int *ratiometric);
  attach_function :CPhidgetInterfaceKit_setRatiometric, [:phid, :int], :int #int CPhidgetInterfaceKit_setRatiometric(CPhidgetInterfaceKitHandle phid, int ratiometric);
  attach_function :CPhidgetInterfaceKit_getDataRate, [:phid, :int, :pointer], :int #int CPhidgetInterfaceKit_getDataRate(CPhidgetInterfaceKitHandle phid, int index, int *milliseconds);
  attach_function :CPhidgetInterfaceKit_setDataRate, [:phid, :int, :int], :int #int CPhidgetInterfaceKit_setDataRate(CPhidgetInterfaceKitHandle phid, int index, int milliseconds);
  attach_function :CPhidgetInterfaceKit_getDataRateMax, [:phid, :int, :pointer], :int #int CPhidgetInterfaceKit_getDataRateMax(CPhidgetInterfaceKitHandle phid, int index, int *max);
  attach_function :CPhidgetInterfaceKit_getDataRateMin, [:phid, :int, :pointer], :int #int CPhidgetInterfaceKit_getDataRateMin(CPhidgetInterfaceKitHandle phid, int index, int *min); 
end