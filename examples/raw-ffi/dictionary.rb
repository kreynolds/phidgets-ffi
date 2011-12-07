require 'rubygems'
require 'phidgets-ffi'

include Phidgets::FFI
Phidgets::Log.enable(:verbose)

pattern = ".*"
key_listener = FFI::MemoryPointer.new(:pointer)

KeyChangedHandler = Proc.new { |dict, obj_ptr, key, value, reason|
  print "Keychange { #{key} => #{value}, reason => '#{reason}'}\n"
}
ErrorHandler = Proc.new { |dict, obj_ptr, code, reason|
  print "Error (#{code}): #{reason} \n"
}
ServerConnectedHandler = Proc.new { |dict, obj_ptr|
  print "Server connected\n"
  CPhidgetDictionary_set_OnKeyChange_Handler(dict, key_listener, pattern, KeyChangedHandler, nil);
}
ServerDisconnectedHandler = Proc.new { |dict, obj_ptr|
  print "Server disconnected\n"
  CPhidgetDictionary_remove_OnKeyChange_Handler(key_listener.get_pointer(0))
}

ptr = FFI::MemoryPointer.new(:pointer)
CPhidgetDictionary.create(ptr)
dictionary = ptr.get_pointer(0)

CPhidget_set_OnServerConnect_Handler(dictionary, ServerConnectedHandler, nil)
CPhidget_set_OnServerDisconnect_Handler(dictionary, ServerDisconnectedHandler, nil)
CPhidget_set_OnError_Handler(dictionary, ErrorHandler, nil)

server_status = FFI::MemoryPointer.new(:int)
address = FFI::MemoryPointer.new(:string)
port = FFI::MemoryPointer.new(:int)
result = CPhidgetDictionary_openRemoteIP(dictionary, "localhost", 5001, nil);
while server_status.get_int(0) != 1
  CPhidgetDictionary_getServerStatus(dictionary, server_status)
end
print "Attached to server\n"

CPhidgetDictionary_getServerAddress(dictionary, address, port)
printf "Address: %s -- Port: %i \n", address.get_pointer(0).read_string, port.get_int(0)

#	Set some keys

sleep 1
CPhidgetDictionary_addKey(dictionary, "TEST1", "1234", 1)
CPhidgetDictionary_addKey(dictionary, "TEST2", "5678", 1);
CPhidgetDictionary_addKey(dictionary, "TEST3", "9012", 0);
CPhidgetDictionary_addKey(dictionary, "TEST4", "3456", 1);

sleep 2

puts "Delete the 4th key...."

sleep 1

CPhidgetDictionary_removeKey(dictionary, "TEST4")

sleep 2

puts "Press any key to end"
$stdin.getc

CPhidgetDictionary_close(dictionary);
CPhidgetDictionary_delete(dictionary);

sleep 10