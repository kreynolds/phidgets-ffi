module Phidgets
  module FFI
    class Error < Exception; end
    attach_function :CPhidget_open, [:phid, :int], :int #int CPhidget_open(CPhidgetHandle phid, int serialNumber);
    attach_function :CPhidget_openLabel, [:phid, :string], :int #int CPhidget_openLabel(CPhidgetHandle phid, const char *label);
    attach_function :CPhidget_close, [:phid], :int #int CPhidget_close(CPhidgetHandle phid);
    attach_function :CPhidget_delete, [:phid], :int #int CPhidget_delete(CPhidgetHandle phid);
    callback :CPhidget_set_OnDetach_Callback, [:phid, :user_ptr], :int
    attach_function :CPhidget_set_OnDetach_Handler, [:phid, :CPhidget_set_OnDetach_Callback, :user_ptr], :int #int CPhidget_set_OnDetach_Handler(CPhidgetHandle phid, int( *fptr)(CPhidgetHandle phid, void *userPtr), void *userPtr);
    callback :CPhidget_set_OnAttach_Callback, [:phid, :user_ptr], :int
    attach_function :CPhidget_set_OnAttach_Handler, [:phid, :CPhidget_set_OnAttach_Callback, :user_ptr], :int #int CPhidget_set_OnAttach_Handler(CPhidgetHandle phid, int( *fptr)(CPhidgetHandle phid, void *userPtr), void *userPtr);
    callback :CPhidget_set_OnServerConnect_Callback, [:phid, :user_ptr], :int
    attach_function :CPhidget_set_OnServerConnect_Handler, [:phid, :CPhidget_set_OnServerConnect_Callback, :user_ptr], :int #int CPhidget_set_OnServerConnect_Handler(CPhidgetHandle phid, int ( *fptr)(CPhidgetHandle phid, void *userPtr), void *userPtr);
    callback :CPhidget_set_OnServerDisconnect_Callback, [:phid, :user_ptr], :int
    attach_function :CPhidget_set_OnServerDisconnect_Handler, [:phid, :CPhidget_set_OnServerDisconnect_Callback, :user_ptr], :int #int CPhidget_set_OnServerDisconnect_Handler(CPhidgetHandle phid, int ( *fptr)(CPhidgetHandle phid, void *userPtr), void *userPtr);
    callback :CPhidget_set_OnError_Callback, [:phid, :user_ptr, :int, :string], :int
    attach_function :CPhidget_set_OnError_Handler, [:phid, :CPhidget_set_OnError_Callback, :user_ptr], :int #int CPhidget_set_OnError_Handler(CPhidgetHandle phid, int( *fptr)(CPhidgetHandle phid, void *userPtr, int errorCode, const char *errorString), void *userPtr);
    attach_function :CPhidget_getDeviceName, [:phid, :pointer], :int #int CPhidget_getDeviceName(CPhidgetHandle phid, const char **deviceName);
    attach_function :CPhidget_getSerialNumber, [:phid, :pointer], :int #int CPhidget_getSerialNumber(CPhidgetHandle phid, int *serialNumber);
    attach_function :CPhidget_getDeviceVersion, [:phid, :pointer], :int #int CPhidget_getDeviceVersion(CPhidgetHandle phid, int *deviceVersion);
    attach_function :CPhidget_getDeviceStatus, [:phid, :pointer], :int #int CPhidget_getDeviceStatus(CPhidgetHandle phid, int *deviceStatus);
    attach_function :CPhidget_getLibraryVersion, [:pointer], :int
    attach_function :CPhidget_getDeviceType, [:phid, :pointer], :int #int CPhidget_getDeviceType(CPhidgetHandle phid, const char **deviceType);
    attach_function :CPhidget_getDeviceLabel, [:phid, :pointer], :int #int CPhidget_getDeviceLabel(CPhidgetHandle phid, const char **deviceLabel);
    attach_function :CPhidget_setDeviceLabel, [:phid, :string], :int #int CPhidget_setDeviceLabel(CPhidgetHandle phid, const char *deviceLabel);
    attach_function :CPhidget_getErrorDescription, [:int, :pointer], :int #int CPhidget_getErrorDescription(int errorCode, const char **errorString);
    attach_function :CPhidget_waitForAttachment, [:phid, :int], :int #int CPhidget_waitForAttachment(CPhidgetHandle phid, int milliseconds);
    attach_function :CPhidget_getServerID, [:phid, :pointer], :int #int CPhidget_getServerID(CPhidgetHandle phid, const char **serverID);
    attach_function :CPhidget_getServerAddress, [:phid, :pointer, :pointer], :int #int CPhidget_getServerAddress(CPhidgetHandle phid, const char **address, int *port);
    attach_function :CPhidget_getServerStatus, [:phid, :pointer], :int #int CPhidget_getServerStatus(CPhidgetHandle phid, int *serverStatus);
    attach_function :CPhidget_getDeviceID, [:phid, :pointer], :int #int CPhidget_getDeviceID(CPhidgetHandle phid, CPhidget_DeviceID *deviceID);
    attach_function :CPhidget_getDeviceClass, [:phid, :pointer], :int #int CPhidget_getDeviceClass(CPhidgetHandle phid, CPhidget_DeviceClass *deviceClass);
    callback :CPhidget_set_OnWillSleep_Callback, [:user_ptr], :int
    attach_function :CPhidget_set_OnWillSleep_Handler, [:CPhidget_set_OnWillSleep_Callback, :user_ptr], :int #int CPhidget_set_OnWillSleep_Handler(int( *fptr)(void *userPtr), void *userPtr);
    callback :CPhidget_set_OnWakeup_Callback, [:user_ptr], :int
    attach_function :CPhidget_set_OnWakeup_Handler, [:CPhidget_set_OnWakeup_Callback, :user_ptr], :int #int CPhidget_set_OnWakeup_Handler(int( *fptr)(void *userPtr), void *userPtr);

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