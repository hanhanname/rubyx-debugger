
require "opal"
require "opal-parser"
require "main_view"

view = MainView.new()
view.draw.append_to($document.body)
