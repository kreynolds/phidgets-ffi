module Phidgets
  module FFI
    typedef :pointer, :dict
    
    KeyChangeReason = enum(
      :changed, 1,
      :added,
      :removed,
      :unchanged
    )
    attach_function :CPhidgetDictionary_create, [:dict], :int #int CPhidgetDictionary_create(CPhidgetDictionaryHandle *dict);
    attach_function :CPhidgetDictionary_close, [:dict], :int #int CPhidgetDictionary_close(CPhidgetDictionaryHandle dict);
    attach_function :CPhidgetDictionary_delete, [:dict], :int #int CPhidgetDictionary_delete(CPhidgetDictionaryHandle dict);
    callback :CPhidgetDictionary_set_OnError_Callback, [:dict, :pointer, :int, :string], :int
    attach_function :CPhidgetDictionary_set_OnError_Handler, [:dict, :CPhidgetDictionary_set_OnError_Callback, :pointer], :int #int CPhidgetDictionary_set_OnError_Handler(CPhidgetDictionaryHandle dict, int( *fptr)(CPhidgetDictionaryHandle, void *userPtr, int errorCode, const char *errorString), void *userPtr);
    attach_function :CPhidgetDictionary_addKey, [:dict, :string, :string, :int], :int #int CPhidgetDictionary_addKey(CPhidgetDictionaryHandle dict, const char *key, const char *value, int persistent);
    attach_function :CPhidgetDictionary_removeKey, [:dict, :string], :int #int CPhidgetDictionary_removeKey(CPhidgetDictionaryHandle dict, const char *pattern);
    attach_function :CPhidgetDictionary_getKey, [:dict, :string, :pointer, :int], :int #int CPhidgetDictionary_getKey(CPhidgetDictionaryHandle dict, const char *key, char *value, int valuelen);
    callback :CPhidgetDictionary_set_OnServerConnect_Callback, [:dict, :pointer], :int
    attach_function :CPhidgetDictionary_set_OnServerConnect_Handler, [:dict, :CPhidgetDictionary_set_OnServerConnect_Callback, :pointer], :int #int CPhidgetDictionary_set_OnServerConnect_Handler(CPhidgetDictionaryHandle dict, int ( *fptr)(CPhidgetDictionaryHandle dict, void *userPtr), void *userPtr);
    callback :CPhidgetDictionary_set_OnServerDisconnect_Callback, [:dict, :pointer], :int
    attach_function :CPhidgetDictionary_set_OnServerDisconnect_Handler, [:dict, :CPhidgetDictionary_set_OnServerDisconnect_Callback, :pointer], :int #int CPhidgetDictionary_set_OnServerDisconnect_Handler(CPhidgetDictionaryHandle dict, int ( *fptr)(CPhidgetDictionaryHandle dict, void *userPtr), void *userPtr);
    attach_function :CPhidgetDictionary_getServerID, [:dict, :pointer], :int #int CPhidgetDictionary_getServerID(CPhidgetDictionaryHandle dict, const char **serverID);
    attach_function :CPhidgetDictionary_getServerAddress, [:dict, :pointer, :pointer], :int #int CPhidgetDictionary_getServerAddress(CPhidgetDictionaryHandle dict, const char **address, int *port);
    attach_function :CPhidgetDictionary_getServerStatus, [:dict, :pointer], :int #int CPhidgetDictionary_getServerStatus(CPhidgetDictionaryHandle dict, int *serverStatus);
    attach_function :CPhidgetDictionary_openRemote, [:dict, :string, :string], :int #int CPhidgetDictionary_openRemote(CPhidgetDictionaryHandle dict, const char *serverID, const char *password);
    attach_function :CPhidgetDictionary_openRemoteIP, [:dict, :string, :int, :string], :int #int CPhidgetDictionary_openRemoteIP(CPhidgetDictionaryHandle dict, const char *address, int port, const char *password);
    callback :CPhidgetDictionary_set_OnKeyChange_Callback, [:dict, :pointer, :string, :string, KeyChangeReason], :int
    attach_function :CPhidgetDictionary_set_OnKeyChange_Handler, [:dict, :pointer, :string, :CPhidgetDictionary_set_OnKeyChange_Callback, :pointer], :int #int CPhidgetDictionary_set_OnKeyChange_Handler(CPhidgetDictionaryHandle dict, CPhidgetDictionaryListenerHandle *dictlistener, const char *pattern, CPhidgetDictionary_OnKeyChange_Function fptr, void *userPtr);
    attach_function :CPhidgetDictionary_remove_OnKeyChange_Handler, [:dict], :int #int CPhidgetDictionary_remove_OnKeyChange_Handler(CPhidgetDictionaryListenerHandle dictlistener);
     
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