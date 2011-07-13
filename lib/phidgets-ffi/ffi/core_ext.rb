class Array
  def to_varargs
    return nil if empty?
    self.map { |a|
      case
      when a.kind_of?(String)
        [:string, a]
      when a.kind_of?(Fixnum)
        [:long_long, a]
      when a.kind_of?(Float)
        [:double, a]
      else
        raise Phidgets::FFI::Error, "Unsupported vararg type: #{a.class}"
      end
    }.flatten
  end
end
