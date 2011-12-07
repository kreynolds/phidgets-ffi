module Phidgets
  module FFI

	attach_function :CPhidgetRFID_create, [:phid], :int
	attach_function :CPhidgetRFID_getOutputCount, [:phid, :pointer], :int    
	attach_function :CPhidgetRFID_getOutputState, [:phid, :int, :pointer], :int    
    attach_function :CPhidgetRFID_setOutputState, [:phid, :int, :int], :int 
	attach_function :CPhidgetRFID_getAntennaOn, [:phid, :pointer], :int    
    attach_function :CPhidgetRFID_setAntennaOn, [:phid, :int], :int 
	attach_function :CPhidgetRFID_getLEDOn, [:phid, :pointer], :int    
    attach_function :CPhidgetRFID_setLEDOn, [:phid, :int], :int 
	attach_function :CPhidgetRFID_getLastTag, [:phid, :pointer], :int    
    attach_function :CPhidgetRFID_getTagStatus, [:phid, :pointer], :int 	
	
	callback :CPhidgetRFID_set_OnOutputChange_Callback, [:phid, :user_ptr, :int, :int], :int
    attach_function :CPhidgetRFID_set_OnOutputChange_Handler, [:phid, :CPhidgetRFID_set_OnOutputChange_Callback, :user_ptr], :int 
	
	callback :CPhidgetRFID_set_OnTag_Callback, [:phid, :user_ptr, :pointer], :int 
    attach_function :CPhidgetRFID_set_OnTag_Handler, [:phid, :CPhidgetRFID_set_OnTag_Callback, :user_ptr], :int 
	
	callback :CPhidgetRFID_set_OnTagLost_Callback, [:phid, :user_ptr, :pointer], :int   
    attach_function :CPhidgetRFID_set_OnTagLost_Handler, [:phid, :CPhidgetRFID_set_OnTagLost_Callback, :user_ptr], :int 
	
module CPhidgetRFID
      def self.method_missing(method, *args, &block)
        if ::Phidgets::FFI.respond_to?("CPhidgetRFID_#{method}".to_sym)
          if (rs = ::Phidgets::FFI.send("CPhidgetRFID_#{method}".to_sym, *args, &block)) != 0
            raise Phidgets::Error.exception_for(rs), Phidgets::FFI.error_description(rs)
          end
        else
          super(method, *args, &block)
        end
      end
    end
  end
end