module Phidgets
  module FFI

   FrequencyCounterFilterTypes = enum(
      :filter_type_zero_crossing, 1,
      :filter_type_logic_level,
      :filter_type_unknown
    )

	attach_function :CPhidgetFrequencyCounter_create, [:phid], :int
    attach_function :CPhidgetFrequencyCounter_getFrequencyInputCount, [:phid, :pointer], :int 
    attach_function :CPhidgetFrequencyCounter_getFrequency, [:phid, :int, :pointer], :int 
    attach_function :CPhidgetFrequencyCounter_getTotalTime, [:phid, :int, :pointer], :int 	
	attach_function :CPhidgetFrequencyCounter_getTotalCount, [:phid, :int, :pointer], :int 	
	attach_function :CPhidgetFrequencyCounter_setTimeout, [:phid, :int, :int], :int 
	attach_function :CPhidgetFrequencyCounter_getTimeout, [:phid, :int, :pointer], :int 
	attach_function :CPhidgetFrequencyCounter_setEnabled, [:phid, :int, :int], :int 
    attach_function :CPhidgetFrequencyCounter_getEnabled, [:phid, :int, :pointer], :int 
    attach_function :CPhidgetFrequencyCounter_getFilter, [:phid, :int, :pointer], :int 
    attach_function :CPhidgetFrequencyCounter_setFilter, [:phid, :int, FrequencyCounterFilterTypes], :int 
	attach_function :CPhidgetFrequencyCounter_reset, [:phid, :int], :int 
    
    callback :CPhidgetFrequencyCounter_set_OnCount_Callback, [:phid, :user_ptr, :int, :int, :int], :int
    attach_function :CPhidgetFrequencyCounter_set_OnCount_Handler, [:phid, :CPhidgetFrequencyCounter_set_OnCount_Callback, :user_ptr], :int 
 
module CPhidgetFrequencyCounter
      def self.method_missing(method, *args, &block)
        if ::Phidgets::FFI.respond_to?("CPhidgetFrequencyCounter_#{method}".to_sym)
          if (rs = ::Phidgets::FFI.send("CPhidgetFrequencyCounter_#{method}".to_sym, *args, &block)) != 0
            raise Phidgets::Error.exception_for(rs), Phidgets::FFI.error_description(rs)
          end
        else
          super(method, *args, &block)
        end
      end
    end
  end
end