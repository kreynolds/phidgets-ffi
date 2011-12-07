module Phidgets
  module Error
    @errors = {}
	
    Phidgets::FFI::ErrorCodes.to_hash.each_pair do |sym, num|
	  eval "@errors[num] = (#{sym.to_s.split("_").map(&:capitalize).join} = Class.new(Exception))"
    end
    
	# Returns the error description corresponding to the error code, or raises an error.
	# @param [Integer] error_code error code
	# @return [String] the error description, or raises an error.
	def self.exception_for(error_code)
		@errors[error_code]
    end
  end
end
