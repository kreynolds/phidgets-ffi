require 'rubygems'
require 'phidgets-ffi'

include Phidgets::FFI

# Will print a line or two to stdout
Log.enableLogging(:verbose, nil)
Log.log(:info, 'identifier', 'arbitrary message')
Log.log(:info, 'identifier', 'arbitrary with a string: %s', "foo")
Log.log(:info, 'identifier', 'arbitrary with an integer: %i', 123)
Log.log(:info, 'identifier', 'arbitrary with an integer: %10.2e', 123.123)
