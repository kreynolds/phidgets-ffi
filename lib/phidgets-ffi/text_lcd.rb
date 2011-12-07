module Phidgets

  # This class represents a PhidgetTextLCD.
  class TextLCD
 
    Klass = Phidgets::FFI::CPhidgetTextLCD
    include Phidgets::Common
    
	# Collection of screens
	# @return [TextLCDScreens] 
    attr_reader :screens

	# Collection of custom characters that is defined for the PhidgetTextLCD
	# @return [TextLCDCustomCharacter] 
    attr_reader :custom_characters

	attr_reader :attributes
    
	# The attributes of a PhidgetTextLCD
	def attributes
      super.merge({
        :screens => screens.size
	  })
    end

  # This class represents a screen a PhidgetTextLCD. All the properties of a screen are stored and modified in this class.
  class TextLCDScreens
    Klass = Phidgets::FFI::CPhidgetTextLCD

	private
    def initialize(handle, index)
      @handle, @index = handle, index.to_i
	  load_rows(0)
    end
	
	public
	# Displays data for the servo motor.
    def inspect
      "#<#{self.class} @index=#{index}>"
	end
	
	# Collection of rows of text display in a PhidgetTextLCD
	# @return [TextLCDScreensRows] 
    attr_reader :rows
	
	# @return [Integer] returns index of the screen, or raises an error.
	def index 
		@index
	end

	# @return [Boolean] returns the back light state of a screen, or raises an error.
    def back_light
      try_set_screen
	  ptr = ::FFI::MemoryPointer.new(:int)
	  Klass.getBacklight(@handle, ptr)
      (ptr.get_int(0) == 0) ? false : true
    end

	# Sets the back light state of a screen, or raises an error.
	# @param [Boolean] new_state new state
	# @return [Boolean] returns the back light state of a screen, or raises an error.
    def back_light=(new_state)
	  try_set_screen
	  tmp = new_state ? 1 : 0
	  Klass.setBacklight(@handle, tmp)
      new_state
    end
	
	# @return [Integer] returns the brightness value of a screen, or raises an error. Not all PhidgetTextLCDs support brightness.
    def brightness
      try_set_screen
	  ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getBrightness(@handle, ptr)
      ptr.get_int(0)
    end

	# Sets the brightness value of a screen, or raises an error. Not all PhidgetTextLCDs support brightness.
	# @param [Integer] new_brightness new brightness(0-255)
	# @return [Integer] returns the brightness value of a screen, or raises an error.
    def brightness=(new_brightness)
      try_set_screen
	  Klass.setBrightness(@handle, new_brightness.to_i)
      new_brightness.to_i
    end
	
	# @return [Integer] returns the contrast of a screen, or raises an error.
    def contrast
      try_set_screen
	  ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getContrast(@handle, ptr)
      ptr.get_int(0)
    end

	# Sets the contrast value of a screen, or raises an error.
	# @param [Integer] new_contrast new contrast(0-255)
	# @return [Integer] returns the contrast value of a screen, or raises an error.
    def contrast=(new_contrast)
      try_set_screen
	  Klass.setContrast(@handle, new_contrast.to_i)
      new_contrast.to_i
    end	

    # The cursor is an underscore which appears directly to the right of the last entered character on the display.	
	# @return [Boolean] returns the cursor state of a screen, or raises an error. 
    def cursor
      try_set_screen
	  ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getCursonOn(@handle, ptr)
      (ptr.get_int(0) == 0) ? false : true
    end

	# Sets the cursor state of a screen, or raises an error.
	# @param [Boolean] new_state new state
	# @return [Boolean] returns the cursor state of a screen, or raises an error.
    def cursor=(new_state)
	  try_set_screen
	  tmp = new_state ? 1 : 0
      Klass.setCursorOn(@handle, tmp)
      new_state
    end

	# The cursor blink is a flashing box which appears directly to the right of the last entered character on the display, in the same apot as the cursor if it is enabled.
	# @return [Boolean] returns the cursor blink state of a screen, or raises an error.
    def cursor_blink
      try_set_screen
	  ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getCursonBlink(@handle, ptr)
      (ptr.get_int(0) == 0) ? false : true
    end

	# Sets the cursor blink state of a screen, or raises an error. 
	# @param [Boolean] new_state new state
	# @return [Boolean] returns the cursor blink state of a screen, or raises an error.
    def cursor_blink=(new_state)
      try_set_screen
	  tmp = new_state ? 1 : 0
      Klass.setCursorBlink(@handle, tmp)
	  new_state
    end

	# @return [Phidgets::FFI::TextLCDScreenSizes] returns the screen size of a screen, or raises an error. Not all PhidgetTextLCDs support screen_size.
	def screen_size
      try_set_screen
	  ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getScreenSize(@handle, ptr)
      Phidgets::FFI::TextLCDScreenSizes[ptr.get_int(0)]
    end

	# Sets the screen size of a screen, or raises an error. Not all PhidgetTextLCDs support screen_size.
	# @param [Phidgets::FFI::TextLCDScreenSizes] new_screen_size new screen size
	# @return [Phidgets::FFI::TextLCDScreenSizes] returns the screen size of a screen, or raises an error.
    def screen_size=(new_screen_size)
	  try_set_screen
      Klass.setScreenSize(@handle, Phidgets::FFI::TextLCDScreenSizes[new_screen_size])
	  
	  load_rows(@index)  #readjust screen rows
      new_screen_size
    end

	# Initializes a screen, or raises an error. Not all PhidgetTextLCDs support initialize
	# @return [Boolean] returns true if the screen was successfully initialize, or raises an error.
    def initialize_screen
      try_set_screen
	  Klass.initialize(@handle)
	  true
    end
	
     # This class represents a row on a PhidgetTextLCD screen. All the properties of a row are stored and modified in this class.
	  class TextLCDScreensRows
		Klass = Phidgets::FFI::CPhidgetTextLCD

		private
		def initialize(handle, row, screen_index)
		  @handle, @row, @screen_index = handle, row.to_i, screen_index.to_i
		end
		
		public
		
		# Sets the display string of a row, or raises an error. 
		#
		# example
		#    lcd.screens[0].rows[1].display_string = "\x48"  #hex for H in ASCII
		#    lcd.screens[0].rows[2].display_string = "\147"  #octal for g in ASCII
		# @param [String] new_string string
		# @return [String] returns the display string, or raises an error.
		def display_string=(new_display_string)
		  if (Common.device_id(@handle).to_s == "textlcd_adapter")
			Klass.setScreen(@handle, @screen_index)
		  end
		  Klass.setDisplayString(@handle, @row, new_display_string)
		  new_display_string
		end

		# Sets a single character for a specific column of a row, or raises an error.
		#
		# example
		#    lcd.screens[0].rows[1].display_character(4, 0x21)  #hex for ! in ASCII
		#    lcd.screens[0].rows[1].display_character(5, 067)  #octal for 7 in ASCII
		# @param [Integer] column column number
		# @param [Integer] new_character new character(in hexadecimal, octal, etc..)
		# @return [Integer] returns the character, or raises an error.
		def display_character(column, new_display_character)
		  if (Common.device_id(@handle).to_s == "textlcd_adapter")
			Klass.setScreen(@handle, @screen_index)
		  end
		  Klass.setDisplayCharacter(@handle, @row, column, new_display_character)
		  new_display_character
		end
		
		# @return [Integer] returns the maximum length of a row, or raises an error.
		def maximum_length
		  ptr = ::FFI::MemoryPointer.new(:int)
		  Klass.getColumnCount(@handle, ptr)
          ptr.get_int(0)
		end
	  end #TextLCDScreensRows
	  
	private
	def load_rows(index)
      ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getRowCount(@handle, ptr)
      @rows = []
	  ptr.get_int(0).times do |i|
	    @rows << TextLCDScreensRows.new(@handle, i, index)
      end
    end

	#Attemps to set the screen for a PhidgetTextLCD Adapter
	def try_set_screen
		if (Common.device_id(@handle).to_s == "textlcd_adapter")
			Klass.setScreen(@handle, @index)
		end
	end

  end #TextLCDScreens
 

  # This class represents a custom character that are defined by a PhidgetTextLCD. All the properties of a custom character are stored and modified in this class.
  class TextLCDCustomCharacter
    Klass = Phidgets::FFI::CPhidgetTextLCD

	private
    def initialize(handle, index)
      @handle, @index = handle, index.to_i
    end
	
	public
	
	# Sets a custom character, or raises an error. The custom character is defined by two integers. See the product manual for more information.
	# example
	#    lcd.custom_characters[0].set_custom_character(949247, 536)  
	# @param [Integer] first_value first value given by the customchar utility
	# @param [Integer] second_value second value given by teh customchar utility
	# @return [Array<Integer>[2]] returns the custom character, or raises an error.
    def set_custom_character(var1, var2)
	  Klass.setCustomCharacter(@handle, @index + 8, var1, var2)
      [var1, var2]
    end
	
	# Returns the character code associated with the custom character, or raises an error.
	# 
	# example
	#    lcd.screens[0].rows[0].display_string = "#{lcd.custom_characters[0].string_code}"
	# @return [String] returns the character code associated with the custom character, or raises an error.
	def string_code
		eval('"' + "\\1#{@index}" + '"')  #ie, returns \10   - \17
	end
	
  end #TextLCDCustomCharacter
  
	private
    
	def load_device_attributes
		load_screens
		load_custom_characters
	end
	
    def load_screens
      ptr = ::FFI::MemoryPointer.new(:int)
      Klass.getScreenCount(@handle, ptr)
      @screens = []
      ptr.get_int(0).times do |i|
        @screens << TextLCDScreens.new(@handle, i)
      end
    end
	
	def load_custom_characters
      @custom_characters = []
      8.times do |i|  #8 custom variables
        @custom_characters << TextLCDCustomCharacter.new(@handle, i)
      end
    end
	
	def remove_specific_event_handlers
	end
  end
   
end