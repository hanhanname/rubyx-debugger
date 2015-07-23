# config.ru
require 'bundler'
Bundler.require
Opal.use_gem "salama"
Opal.use_gem "salama-arm"

require "react/source"


run Opal::Server.new {|s|
  s.append_path 'app'
  s.append_path 'lib'
  s.append_path File.dirname(::React::Source.bundled_path_for("react-with-addons.js"))
  s.main = 'debugger'
  s.debug = true
  s.source_map = true
  s.index_path = "index.html.erb"
}
