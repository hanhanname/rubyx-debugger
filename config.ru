require 'bundler'
Bundler.require
require 'tilt/erb'

require_relative "lib/parse_task"

require "opal"
require 'opal-browser'

Opal.use_gem("salama")
Opal.use_gem("salama-arm")

class DebugServer < Opal::Server
  def call(env)
    if( env["REQUEST_PATH"] == "/tasks.json")
      [200, { 'Content-Type' => 'text/json' }, [ParseTask.new.parse(1).to_json]]
    else
      super(env)
    end
  end
end
run DebugServer.new { |s|
  s.main = 'debugger'
  s.append_path 'lib'
  s.append_path 'assets'
#  s.source_map = true
  s.debug = !ENV["DEBUG"].nil?

  s.index_path = "index.html.erb"
  s.sprockets.cache = Sprockets::Cache::MemoryStore.new(5000)
}
