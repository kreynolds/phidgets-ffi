require 'rubygems'
require 'phidgets-ffi'
require File.dirname(__FILE__) + '/../lib/phidgets-ffi/dictionary'
Phidgets::Log.enable(:verbose)

puts "Library Version: #{Phidgets::FFI.library_version}"
Phidgets::Dictionary.new do |dict|
  dict.on_error do |obj, code, reason|
    puts "Error (#{code}): #{reason}"
  end
  dict.on_connect do |obj|
    print "Connected!\n"
  end
  dict.on_disconnect do |obj|
    print "Disconnected!\n"
  end
  
  dict.on_change('fnord') do |obj, key, val, reason|
      print "Fnord key: #{key} => #{val}, #{reason}\n"
  end
  dict.on_change do |obj, key, val, reason|
      print "Every key: #{key} => #{val}, #{reason}\n"
  end
  dict.on_change('test') do |obj, key, val, reason|
      print "Keys matching test: #{key} => #{val}, #{reason}\n"
  end

  puts "Listening to: #{dict.listeners.inspect}"

  dict.remove_on_change('fnord')

  puts "Listening to: #{dict.listeners.inspect}"

  dict["fnord"] = "This is a fnordic key"
  dict["test"] = "This is a key that is called test"
  dict["fnord"] = nil
  dict["snoop"] = nil
  20.times do |i|
    print "#{i}\n"
    begin
      dict["testerson"] = "This is another test matching key"
    rescue Phidgets::Error::NetworkNotConnected
    end
    sleep 1
  end
end