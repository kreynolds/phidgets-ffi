module Phidgets
  module FFI
    class Error < Exception; end
    
	attach_function :CPhidget_open, [:phid, :int], :int
    attach_function :CPhidget_openRemote, [:phid, :int, :string, :string], :int
	attach_function :CPhidget_openRemoteIP, [:phid, :int, :string, :int, :string], :int
	attach_function :CPhidget_openLabelRemote, [:phid, :string, :string, :string], :int
	attach_function :CPhidget_openLabelRemoteIP, [:phid, :string, :string, :int, :string], :int
	attach_function :CPhidget_openLabel, [:phid, :string], :int
    attach_function :CPhidget_close, [:phid], :int 
    attach_function :CPhidget_delete, [:phid], :int 
	attach_function :CPhidget_getDeviceName, [:phid, :pointer], :int 
    attach_function :CPhidget_getSerialNumber, [:phid, :pointer], :int 
    attach_function :CPhidget_getDeviceVersion, [:phid, :pointer], :int 
    attach_function :CPhidget_getDeviceStatus, [:phid, :pointer], :int 
    attach_function :CPhidget_getLibraryVersion, [:pointer], :int
    attach_function :CPhidget_getDeviceType, [:phid, :pointer], :int 
    attach_function :CPhidget_getDeviceLabel, [:phid, :pointer], :int 
    attach_function :CPhidget_setDeviceLabel, [:phid, :string], :int 
    attach_function :CPhidget_getErrorDescription, [:int, :pointer], :int
    
	@blocking = true
	attach_function :CPhidget_waitForAttachment, [:phid, :int], :int, :blocking => true  
    
	attach_function :CPhidget_getServerID, [:phid, :pointer], :int 
    attach_function :CPhidget_getServerAddress, [:phid, :pointer, :pointer], :int 
    attach_function :CPhidget_getServerStatus, [:phid, :pointer], :int 
    attach_function :CPhidget_getDeviceID, [:phid, :pointer], :int 
    attach_function :CPhidget_getDeviceClass, [:phid, :pointer], :int 
    
	callback :CPhidget_set_OnDetach_Callback, [:phid, :user_ptr], :int
	attach_function :CPhidget_set_OnDetach_Handler, [:phid, :CPhidget_set_OnDetach_Callback, :user_ptr], :int
    
	callback :CPhidget_set_OnAttach_Callback, [:phid, :user_ptr], :int
	attach_function :CPhidget_set_OnAttach_Handler, [:phid, :CPhidget_set_OnAttach_Callback, :user_ptr], :int
    
	callback :CPhidget_set_OnServerConnect_Callback, [:phid, :user_ptr], :int
    attach_function :CPhidget_set_OnServerConnect_Handler, [:phid, :CPhidget_set_OnServerConnect_Callback, :user_ptr], :int
    
	callback :CPhidget_set_OnServerDisconnect_Callback, [:phid, :user_ptr], :int
    attach_function :CPhidget_set_OnServerDisconnect_Handler, [:phid, :CPhidget_set_OnServerDisconnect_Callback, :user_ptr], :int
    
	callback :CPhidget_set_OnError_Callback, [:phid, :user_ptr, :int, :string], :int
    attach_function :CPhidget_set_OnError_Handler, [:phid, :CPhidget_set_OnError_Callback, :user_ptr], :int
    

	if RbConfig::CONFIG['target_os'] =~ /darwin/ #Mac OS X
		callback :CPhidget_set_OnWillSleep_Callback, [:user_ptr], :int
		attach_function :CPhidget_set_OnWillSleep_Handler, [:CPhidget_set_OnWillSleep_Callback, :user_ptr], :int
		callback :CPhidget_set_OnWakeup_Callback, [:user_ptr], :int
		attach_function :CPhidget_set_OnWakeup_Handler, [:CPhidget_set_OnWakeup_Callback, :user_ptr], :int 
	end
	
    module Common
      def self.method_missing(method, *args, &block)
        if ::Phidgets::FFI.respond_to?("CPhidget_#{method}".to_sym)
			if (rs = ::Phidgets::FFI.send("CPhidget_#{method}".to_sym, *args, &block)) != 0
			raise Phidgets::Error.exception_for(rs), Phidgets::FFI.error_description(rs)
          end
        else
          super(method, *args, &block)
        end
      end
    end
  end
end