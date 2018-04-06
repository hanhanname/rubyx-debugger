require 'bundler'
Bundler.require
require 'tilt/erb'

require "opal"
require 'opal-browser'

Opal.use_gem("rubyx")
Opal.use_gem("ast")
Risc.machine.boot

class DebugServer < Opal::Server
  def ball(env)
    path = env["REQUEST_PATH"]
    return super(env) unless path.include?("json")
    route = path[1 .. path.index(".") - 1]
    [200, { 'Content-Type' => 'text/json' },  code(route) ]
  end

  def code at
    soml = File.new("codes/#{at}.soml").read
    syntax  = Parser::Salama.new.parse_with_debug(soml)
    parts = Parser::Transform.new.apply(syntax)
    [parts.inspect]
  end
end

run Opal::Sprockets::Server.new { |s|
  s.main = 'debugger.js.rb'
  s.append_path 'lib'
  s.append_path 'assets'
  s.debug = !ENV["DEBUG"].nil?
#  s.source_map = true
  s.index_path = "index.html.erb"
  s.sprockets.cache = Sprockets::Cache::MemoryStore.new(10000)
}
