require 'rubygems'
require 'phidgets-ffi'

# Will print a line or two to stdout
Phidgets::Log.enable(:verbose)
Phidgets::Log.info('identifier', 'arbitrary message')
Phidgets::Log.warning('identifier', 'arbitrary with a string: %s', "foo")
Phidgets::Log.error('identifier', 'arbitrary with an integer: %i', 123)
Phidgets::Log.verbose('identifier', 'arbitrary with an integer: %10.2e', 123.123)
