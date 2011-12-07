require 'rubygems'
require 'phidgets-ffi'

Phidgets::Log.enable(:verbose)

puts "Library Version: #{Phidgets::FFI.library_version}"

dict = Phidgets::Dictionary.new

dict.on_error do |obj, code, reason|
    puts "Error (#{code}): #{reason}"
  end

  dict.on_connect do |obj|
    puts "Connected!"
		#Listening for every pattern
		dict.on_change do |obj, key, val, reason|
		  puts "Every key: #{key} => #{val}-- #{reason}"
		end

		dict.on_change('snoop') do |obj, key, val, reason|
		  puts "Keys matching snoop: #{key} => #{val}-- #{reason}"
		end

		#Patterns an also be of ruby type: Regexp
		dict.on_change(/test.*/) do |obj, key, val, reason|  
		  puts "Keys matching /test.*/: #{key} => #{val}-- #{reason}"
		end
	end

	dict.on_disconnect do |obj|
    puts "Disconnected!"
  end
  
options = {:address => 'localhost', :port => 5001, :password => nil}
dict.open(options)
  
sleep 5
if dict.status.to_s == 'connected'
	puts "Listening to: #{dict.listeners.inspect}"

	dict.remove_on_change('snoop')

	puts "Listening to: #{dict.listeners.inspect}"


	dict["fnord"] = {:value => "This is a fnordic key", :persistent => true}
	dict["test"] = {:value => "This is a key that is called test", :persistent => false}
	dict["test"] = nil
	  
	20.times do |i|
		print "#{i}\n"
		begin
		  dict["snoop"] = {:value => "value: #{i}"}
		  dict["testerson"] = {:value => "This is another test matching key"}
		  
		rescue Phidgets::Error::NetworkNotConnected
	    end
	    sleep 1
	end
end
