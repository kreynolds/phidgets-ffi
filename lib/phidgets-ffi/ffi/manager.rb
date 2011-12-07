module Phidgets
  module FFI

	require 'sys/uname'
	os_name = Sys::Uname.sysname
	parsed_os_name = os_name.downcase
	if parsed_os_name.include? "darwin" #Mac OS X
		FFI_POINTER_SIZE = 4  
    else  #Linux
		FFI_POINTER_SIZE = 8  
	end
	
	typedef :pointer, :phidm

    attach_function :CPhidgetManager_create, [:phidm], :int 
    attach_function :CPhidgetManager_open, [:phidm], :int 
    attach_function :CPhidgetManager_openRemote, [:phidm, :string, :string], :int 
	attach_function :CPhidgetManager_openRemoteIP, [:phidm, :string, :int, :string], :int 
	attach_function :CPhidgetManager_close, [:phidm], :int 
    attach_function :CPhidgetManager_delete, [:phidm], :int
    attach_function :CPhidgetManager_getAttachedDevices, [:phidm, :pointer, :pointer], :int 
    attach_function :CPhidgetManager_freeAttachedDevicesArray, [:pointer], :int 
    attach_function :CPhidgetManager_getServerID, [:phidm, :pointer], :int
    attach_function :CPhidgetManager_getServerAddress, [:phidm, :pointer, :pointer], :int
	attach_function :CPhidgetManager_getServerStatus, [:phidm, :pointer], :int

	callback :CPhidgetManager_set_OnAttach_Callback, [:phid, :user_ptr], :int
    attach_function :CPhidgetManager_set_OnAttach_Handler, [:phidm, :CPhidgetManager_set_OnAttach_Callback, :user_ptr], :int 
	
	callback :CPhidgetManager_set_OnDetach_Callback, [:phid, :user_ptr], :int
    attach_function :CPhidgetManager_set_OnDetach_Handler, [:phidm, :CPhidgetManager_set_OnDetach_Callback, :user_ptr], :int 
    
	callback :CPhidgetManager_set_OnError_Callback, [:phidm, :user_ptr, :int, :string], :int
    attach_function :CPhidgetManager_set_OnError_Handler, [:phidm, :CPhidgetManager_set_OnError_Callback, :user_ptr], :int 
	
	callback :CPhidgetManager_set_OnServerConnect_Callback, [:phidm, :user_ptr], :int
    attach_function :CPhidgetManager_set_OnServerConnect_Handler, [:phidm, :CPhidgetManager_set_OnServerConnect_Callback, :user_ptr], :int 
	
	callback :CPhidgetManager_set_OnServerDisconnect_Callback, [:phidm, :user_ptr], :int
    attach_function :CPhidgetManager_set_OnServerDisconnect_Handler, [:phidm, :CPhidgetManager_set_OnServerDisconnect_Callback, :user_ptr], :int 
	
	module CPhidgetManager
      def self.method_missing(method, *args, &block)
        if ::Phidgets::FFI.respond_to?("CPhidgetManager_#{method}".to_sym)
          if (rs = ::Phidgets::FFI.send("CPhidgetManager_#{method}".to_sym, *args, &block)) != 0
            raise Phidgets::Error.exception_for(rs), Phidgets::FFI.error_description(rs)
          end
        else
          super(method, *args, &block)
        end
      end
    end
  end
end