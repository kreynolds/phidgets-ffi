module Phidgets
  module FFI
    typedef :pointer, :dict
    
    KeyChangeReason = enum(
      :changed, 1,
      :added,
      :removed,
      :unchanged
    )

    attach_function :CPhidgetDictionary_create, [:dict], :int 
    attach_function :CPhidgetDictionary_openRemote, [:dict, :string, :string], :int 
    attach_function :CPhidgetDictionary_openRemoteIP, [:dict, :string, :int, :string], :int 
    attach_function :CPhidgetDictionary_close, [:dict], :int 
    attach_function :CPhidgetDictionary_delete, [:dict], :int 
    attach_function :CPhidgetDictionary_addKey, [:dict, :string, :string, :int], :int
    attach_function :CPhidgetDictionary_removeKey, [:dict, :string], :int 
    attach_function :CPhidgetDictionary_getKey, [:dict, :string, :pointer, :int], :int
    attach_function :CPhidgetDictionary_getServerID, [:dict, :pointer], :int 
    attach_function :CPhidgetDictionary_getServerAddress, [:dict, :pointer, :pointer], :int
    attach_function :CPhidgetDictionary_getServerStatus, [:dict, :pointer], :int 
    
    callback :CPhidgetDictionary_set_OnError_Callback, [:dict, :pointer, :int, :string], :int
    attach_function :CPhidgetDictionary_set_OnError_Handler, [:dict, :CPhidgetDictionary_set_OnError_Callback, :pointer], :int 
	
	callback :CPhidgetDictionary_set_OnServerConnect_Callback, [:dict, :pointer], :int
    attach_function :CPhidgetDictionary_set_OnServerConnect_Handler, [:dict, :CPhidgetDictionary_set_OnServerConnect_Callback, :pointer], :int
	
	callback :CPhidgetDictionary_set_OnServerDisconnect_Callback, [:dict, :pointer], :int
    attach_function :CPhidgetDictionary_set_OnServerDisconnect_Handler, [:dict, :CPhidgetDictionary_set_OnServerDisconnect_Callback, :pointer], :int 
	
	callback :CPhidgetDictionary_set_OnKeyChange_Callback, [:dict, :pointer, :string, :string, KeyChangeReason], :int
    attach_function :CPhidgetDictionary_set_OnKeyChange_Handler, [:dict, :pointer, :string, :CPhidgetDictionary_set_OnKeyChange_Callback, :pointer], :int
	
	attach_function :CPhidgetDictionary_remove_OnKeyChange_Handler, [:dict], :int
	
    module CPhidgetDictionary
      def self.method_missing(method, *args, &block)
        if ::Phidgets::FFI.respond_to?("CPhidgetDictionary_#{method}".to_sym)
          if (rs = ::Phidgets::FFI.send("CPhidgetDictionary_#{method}".to_sym, *args, &block)) != 0
            raise Phidgets::Error.exception_for(rs), Phidgets::FFI.error_description(rs)
          end
        else
          super(method, *args, &block)
        end
      end
    end
  end
end