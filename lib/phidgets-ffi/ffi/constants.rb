module Phidgets
  module FFI
    typedef :pointer, :phid
    typedef :pointer, :user_ptr
        
    DeviceStatus = enum(
      :detached, 0,
      :attached
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

    ErrorCodes = enum(
      :ok, 0,
      :not_found,
      :no_memory,
      :unexpected,
      :invalid_arg,
      :not_attached,
      :interrupted,
      :invalid,
      :network,
      :unknown_val,
      :bad_password,
      :unsupported,
      :duplicate,
      :timeout,
      :out_of_bounds,
      :event,
      :network_not_connected,
      :wrong_device,
      :closed,
      :bad_version,
      :error_code_count
    )
  end
end