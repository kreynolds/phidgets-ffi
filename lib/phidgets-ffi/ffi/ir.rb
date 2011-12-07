module Phidgets
  module FFI

  RAWDATA_LONGSPACE = 0x7fffffff  
	
   IREncoding = enum(
      :encoding_unknown , 1,
      :encoding_space,
      :encoding_pulse,
	  :encoding_biphase,
	  :encoding_rc5,
	  :encoding_rc6
    )

	IRLength = enum(
      :length_unknown , 1,
      :length_constant,
      :length_variable
    )
	
	attach_function :CPhidgetIR_create, [:phid], :int
    attach_function :CPhidgetIR_Transmit, [:phid, :pointer, :pointer], :int    
    attach_function :CPhidgetIR_TransmitRepeat, [:phid], :int 
	attach_function :CPhidgetIR_TransmitRaw, [:phid, :pointer, :int, :int, :int, :int], :int 	
	attach_function :CPhidgetIR_getRawData, [:phid, :pointer, :pointer], :int 	
	attach_function :CPhidgetIR_getLastCode, [:phid, :pointer, :pointer, :pointer], :int
	attach_function :CPhidgetIR_getLastLearnedCode, [:phid, :pointer, :pointer, :pointer], :int 
	
	callback :CPhidgetIR_set_OnCode_Callback, [:phid, :user_ptr, :pointer, :int, :int, :int], :int
    attach_function :CPhidgetIR_set_OnCode_Handler, [:phid, :CPhidgetIR_set_OnCode_Callback, :user_ptr], :int 
	
	callback :CPhidgetIR_set_OnLearn_Callback, [:phid, :user_ptr, :pointer, :int, :pointer], :int 
    attach_function :CPhidgetIR_set_OnLearn_Handler, [:phid, :CPhidgetIR_set_OnLearn_Callback, :user_ptr], :int 
	
	callback :CPhidgetIR_set_OnRawData_Callback, [:phid, :user_ptr, :pointer, :int], :int   
    attach_function :CPhidgetIR_set_OnRawData_Handler, [:phid, :CPhidgetIR_set_OnRawData_Callback, :user_ptr], :int 
	
module CPhidgetIR
      def self.method_missing(method, *args, &block)
        if ::Phidgets::FFI.respond_to?("CPhidgetIR_#{method}".to_sym)
          if (rs = ::Phidgets::FFI.send("CPhidgetIR_#{method}".to_sym, *args, &block)) != 0
            raise Phidgets::Error.exception_for(rs), Phidgets::FFI.error_description(rs)
          end
        else
          super(method, *args, &block)
        end
      end
    end
  end
end