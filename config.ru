# config.ru
require 'bundler'
Bundler.require

Opal.use_gem "salama"
Opal.use_gem "salama-arm"

require "tilt/erb"
require "json"
require "react/source"

class DebugServer < Opal::Server

  def parse(num)
    string_input    = '"Hello again".putstring()'
    parser = Parser::Salama.new
    out = parser.parse(string_input)
    parts = Parser::Transform.new.apply(out)
    parts.to_basic
  end


  def call(env)
    if env['PATH_INFO'].include? "/parse.json"
      parse_out =    parse(1).to_s
      [200, { 'Content-Type' => 'text/json' }, [parse_out]]
    else
      super
    end
  end

end
run DebugServer.new {|s|
  s.append_path 'app'
  s.append_path 'lib'
  s.append_path File.dirname(::React::Source.bundled_path_for("react-with-addons.js"))
  s.main = 'main'
  s.debug = true
  s.source_map = true
  s.index_path = "index.html.erb"
}
