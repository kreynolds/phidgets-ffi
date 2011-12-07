module Phidgets
  module FFI

   TextLCDScreenSizes = enum(
      :screen_size_none, 1,
	  :screen_size_1x8,
      :screen_size_2x8,
      :screen_size_1x16,
	  :screen_size_2x16,
	  :screen_size_4x16,
	  :screen_size_2x20,
	  :screen_size_4x20,
	  :screen_size_2x24,
	  :screen_size_1x40,
	  :screen_size_2x40,
	  :screen_size_4x40,
	  :screen_size_unknown
    )

	attach_function :CPhidgetTextLCD_create, [:phid], :int
    attach_function :CPhidgetTextLCD_getRowCount, [:phid, :pointer], :int 
    attach_function :CPhidgetTextLCD_getColumnCount, [:phid, :pointer], :int 
    attach_function :CPhidgetTextLCD_getBacklight, [:phid, :pointer], :int 
    attach_function :CPhidgetTextLCD_setBacklight, [:phid, :int], :int 
	attach_function :CPhidgetTextLCD_getBrightness, [:phid, :pointer], :int 
    attach_function :CPhidgetTextLCD_setBrightness, [:phid, :int], :int 
	attach_function :CPhidgetTextLCD_getContrast, [:phid, :pointer], :int 
    attach_function :CPhidgetTextLCD_setContrast, [:phid, :int], :int 
	attach_function :CPhidgetTextLCD_getCursorOn, [:phid, :pointer], :int 
    attach_function :CPhidgetTextLCD_setCursorOn, [:phid, :int], :int 
	attach_function :CPhidgetTextLCD_getCursorBlink, [:phid, :pointer], :int 
    attach_function :CPhidgetTextLCD_setCursorBlink, [:phid, :int], :int 
	attach_function :CPhidgetTextLCD_setCustomCharacter, [:phid, :int, :int, :int], :int 
	attach_function :CPhidgetTextLCD_setDisplayCharacter, [:phid, :int, :int, :uchar], :int 	
	attach_function :CPhidgetTextLCD_setDisplayString, [:phid, :int, :pointer], :int
    attach_function :CPhidgetTextLCD_getScreenCount, [:phid, :pointer], :int 
	attach_function :CPhidgetTextLCD_getScreen, [:phid, :pointer], :int 
    attach_function :CPhidgetTextLCD_setScreen, [:phid, :int], :int 
    attach_function :CPhidgetTextLCD_getScreenSize, [:phid, :pointer], :int 
    attach_function :CPhidgetTextLCD_setScreenSize, [:phid, TextLCDScreenSizes], :int 
	attach_function :CPhidgetTextLCD_initialize, [:phid], :int 
		
module CPhidgetTextLCD
      def self.method_missing(method, *args, &block)
        if ::Phidgets::FFI.respond_to?("CPhidgetTextLCD_#{method}".to_sym)
          if (rs = ::Phidgets::FFI.send("CPhidgetTextLCD_#{method}".to_sym, *args, &block)) != 0
            raise Phidgets::Error.exception_for(rs), Phidgets::FFI.error_description(rs)
          end
        else
          super(method, *args, &block)
        end
      end
    end
  end
end