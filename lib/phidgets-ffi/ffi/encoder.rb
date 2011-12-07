module Phidgets
  module FFI

	attach_function :CPhidgetEncoder_create, [:phid], :int
    attach_function :CPhidgetEncoder_getInputCount, [:phid, :pointer], :int 
    attach_function :CPhidgetEncoder_getInputState, [:phid, :int, :pointer], :int 
    attach_function :CPhidgetEncoder_getEncoderCount, [:phid, :pointer], :int 
	attach_function :CPhidgetEncoder_getPosition, [:phid, :int, :pointer], :int 
	attach_function :CPhidgetEncoder_setPosition, [:phid, :int, :int], :int 
    attach_function :CPhidgetEncoder_getIndexPosition, [:phid, :int, :pointer], :int 
    attach_function :CPhidgetEncoder_getEnabled, [:phid, :int, :pointer], :int 
    attach_function :CPhidgetEncoder_setEnabled, [:phid, :int, :int], :int 

	callback :CPhidgetEncoder_set_OnInputChange_Callback, [:phid, :user_ptr, :int, :int], :int
    attach_function :CPhidgetEncoder_set_OnInputChange_Handler, [:phid, :CPhidgetEncoder_set_OnInputChange_Callback, :user_ptr], :int 
	
    callback :CPhidgetEncoder_set_OnPositionChange_Callback, [:phid, :user_ptr, :int, :int, :int], :int
    attach_function :CPhidgetEncoder_set_OnPositionChange_Handler, [:phid, :CPhidgetEncoder_set_OnPositionChange_Callback, :user_ptr], :int 

module CPhidgetEncoder
      def self.method_missing(method, *args, &block)
        if ::Phidgets::FFI.respond_to?("CPhidgetEncoder_#{method}".to_sym)
          if (rs = ::Phidgets::FFI.send("CPhidgetEncoder_#{method}".to_sym, *args, &block)) != 0
            raise Phidgets::Error.exception_for(rs), Phidgets::FFI.error_description(rs)
          end
        else
          super(method, *args, &block)
        end
      end
    end
  end
end