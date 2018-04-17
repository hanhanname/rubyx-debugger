require 'bundler'
Bundler.require
require 'tilt/erb'
require "opal"
require 'opal-sprockets'

Opal.use_gem("rubyx")

run Opal::Sprockets::Server.new { |s|
  s.main = 'debugger.js.rb'
  s.append_path 'lib'
  s.append_path 'assets'
  s.debug = !ENV["DEBUG"].nil?
  s.index_path = "index.html.erb"
  s.sprockets.cache = Sprockets::Cache::MemoryStore.new(50000)
}
