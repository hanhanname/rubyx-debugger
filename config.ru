require 'bundler'
Bundler.require
require 'tilt/erb'

require "opal"
require 'opal-browser'

Opal.use_gem("salama")
Opal.use_gem("ast")
Opal.use_gem("salama-arm")
Register.machine.boot

class DebugServer < Opal::Server
  def call(env)
    path = env["REQUEST_PATH"]
    return super(env) unless path.include?("json")
    route = path[1 .. path.index(".") - 1]
    if( route == "codes")
      [200, { 'Content-Type' => 'text/json' },  codes ]
    else
      [200, { 'Content-Type' => 'text/json' },  code(route) ]
    end
  end
  def codes
    [Dir["codes/*.psol"].collect{|f| f.sub("codes/","").sub(".psol","")}.join("----")]
  end
  def code at
    phisol = File.new("codes/#{at}.psol").read
    syntax  = Parser::Salama.new.parse_with_debug(phisol)
    parts = Parser::Transform.new.apply(syntax)
    [parts.inspect]
  end
end
run DebugServer.new { |s|
  s.main = 'debugger'
  s.append_path 'lib'
  s.append_path 'assets'
  s.debug = !ENV["DEBUG"].nil?

  s.index_path = "index.html.erb"
  s.sprockets.cache = Sprockets::Cache::MemoryStore.new(5000)
}
