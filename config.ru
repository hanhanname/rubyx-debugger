# config.ru
require 'bundler'
Bundler.require

require "react/source"


opal = Opal::Server.new {|s|
  s.append_path 'app'
  s.append_path File.dirname(::React::Source.bundled_path_for("react-with-addons.js"))
  s.main = 'debuger'
  s.debug = true
  s.source_map = true
}

map '/assets' do
  run opal.sprockets
end


post "/parse.json" do

#  File.write('./parse.json', JSON.pretty_generate(comments, :indent => '    '))
#  JSON.generate(comments)
end

get '/' do
  <<-HTML
    <!doctype html>
    <html>
      <head>
        <title>Salama Debugger</title>
        <link rel="stylesheet" href="base.css" />
        <script src="https://code.jquery.com/jquery-2.1.3.min.js"></script>
        <script src="/assets/react-with-addons.js"></script>
        <script src="/assets/debugger.js"></script>
        <script>#{Opal::Processor.load_asset_code(opal.sprockets, "debugger.js")}</script>
      </head>
      <body>
        <div id="content"></div>
      </body>
    </html>
  HTML
end

run Sinatra::Application
