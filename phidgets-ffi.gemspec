# -*- encoding: utf-8 -*-
require File.expand_path("../lib/phidgets-ffi/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "phidgets-ffi"
  s.version     = Phidgets::FFI::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Kelley Reynolds"]
  s.email       = ["kelley@insidesystems.net"]
  s.homepage    = "https://github.com/kreynolds/phidgets-ffi"
  s.summary     = "FFI Bindings for the Phidget Library"
  s.description = "FFI Bindings for the Phidget Library"

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "phidgets-ffi"

  s.add_development_dependency "bundler", ">= 1.0.0"
  s.add_runtime_dependency "ffi", ">= 1.0.9"

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end
