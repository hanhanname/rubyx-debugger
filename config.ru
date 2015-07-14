require 'bundler'
Bundler.require

require "opal"
Opal.use_gem("salama")

run Opal::Server.new { |s|
  s.main = 'debugger'
  s.append_path 'lib'
  s.debug = true
}
