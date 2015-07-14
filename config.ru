require 'bundler'
Bundler.require
require_relative "lib/parse_task"

require "opal"
Opal.use_gem("salama")

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
  s.source_map = true
  s.debug = true
}
