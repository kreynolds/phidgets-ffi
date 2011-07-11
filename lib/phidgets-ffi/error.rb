module Phidgets
  module Error
    @errors = {}
    Phidgets::FFI::ErrorCodes.to_hash.each_pair do |sym, num|
      eval "@errors[num] = (#{sym.to_s.split("_").map(&:capitalize).join} = Class.new(Exception))"
    end
    def self.exception_for(error_code)
      @errors[error_code]
    end
  end
end
