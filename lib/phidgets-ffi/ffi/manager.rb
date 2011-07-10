module Phidgets
  module FFI
    typedef :pointer, :phidm

    attach_function :CPhidgetManager_create, [:phidm], :int #int CPhidgetManager_create(CPhidgetManagerHandle *phidm);
    attach_function :CPhidgetManager_open, [:phidm], :int #int CPhidgetManager_open(CPhidgetManagerHandle phidm);
    attach_function :CPhidgetManager_close, [:phidm], :int #int CPhidgetManager_close(CPhidgetManagerHandle phidm);
    attach_function :CPhidgetManager_delete, [:phidm], :int #int CPhidgetManager_delete(CPhidgetManagerHandle phidm);
    callback :CPhidgetManager_set_OnAttach_Callback, [:phid, :user_ptr], :int
    attach_function :CPhidgetManager_set_OnAttach_Handler, [:phidm, :CPhidgetManager_set_OnAttach_Callback, :user_ptr], :int #int CPhidgetManager_set_OnAttach_Handler(CPhidgetManagerHandle phidm, int ( *fptr)(CPhidgetHandle phid, void *userPtr), void *userPtr);
    callback :CPhidgetManager_set_OnDetach_Callback, [:phid, :user_ptr], :int
    attach_function :CPhidgetManager_set_OnDetach_Handler, [:phidm, :CPhidgetManager_set_OnDetach_Callback, :user_ptr], :int #int CPhidgetManager_set_OnDetach_Handler(CPhidgetManagerHandle phidm, int ( *fptr)(CPhidgetHandle phid, void *userPtr), void *userPtr);
    attach_function :CPhidgetManager_getAttachedDevices, [:phidm, :pointer, :pointer], :int #int CPhidgetManager_getAttachedDevices(CPhidgetManagerHandle phidm, CPhidgetHandle *phidArray[], int *count);
    attach_function :CPhidgetManager_freeAttachedDevicesArray, [:pointer], :int #int CPhidgetManager_freeAttachedDevicesArray(CPhidgetHandle phidArray[]);
    callback :CPhidgetManager_set_OnError_Callback, [:phidm, :user_ptr, :int, :string], :int
    attach_function :CPhidgetManager_set_OnError_Handler, [:phidm, :CPhidgetManager_set_OnError_Callback, :user_ptr], :int #int CPhidgetManager_set_OnError_Handler(CPhidgetManagerHandle phidm, int( *fptr)(CPhidgetManagerHandle phidm, void *userPtr, int errorCode, const char *errorString), void *userPtr);
    callback :CPhidgetManager_set_OnServerConnect_Callback, [:phidm, :user_ptr], :int
    attach_function :CPhidgetManager_set_OnServerConnect_Handler, [:phidm, :CPhidgetManager_set_OnServerConnect_Callback, :user_ptr], :int #int CPhidgetManager_set_OnServerConnect_Handler(CPhidgetManagerHandle phidm, int ( *fptr)(CPhidgetManagerHandle phidm, void *userPtr), void *userPtr);
    callback :CPhidgetManager_set_OnServerDisconnect_Callback, [:phidm, :user_ptr], :int
    attach_function :CPhidgetManager_set_OnServerDisconnect_Handler, [:phidm, :CPhidgetManager_set_OnServerDisconnect_Callback, :user_ptr], :int #int CPhidgetManager_set_OnServerDisconnect_Handler(CPhidgetManagerHandle phidm, int ( *fptr)(CPhidgetManagerHandle phidm, void *userPtr), void *userPtr);
    attach_function :CPhidgetManager_getServerID, [:phidm, :pointer], :int #int CPhidgetManager_getServerID(CPhidgetManagerHandle phidm, const char **serverID);
    attach_function :CPhidgetManager_getServerAddress, [:phidm, :pointer, :pointer], :int#int CPhidgetManager_getServerAddress(CPhidgetManagerHandle phidm, const char **address, int *port);
  end
end