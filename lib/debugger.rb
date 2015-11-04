
require "opal"
require "opal-parser"

require "logger"
require 'browser'
require 'browser/http'
require 'native'
require "salama"
require "salama-reader"
require "ast"
require "interpreter/interpreter"
# the base, our own litle framework, allows for child and parent views and handles updates
require "base/list_view"
# each seperate view is in it's own class.
require "views/switch_view"
require "views/status_view"
require "views/source_view"
require "views/instruction_view"
require "views/registers_view"

class MainView < ListView
  include AST::Sexp

  def initialize
    machine = Register.machine.boot
    code = s(:statements, s(:class, :Object, s(:derives, nil),
                s(:statements, s(:class_field, :Integer, :x))))
    Soml.compile( code  )
    machine.collect
    @interpreter = Interpreter::Interpreter.new
    super( [SwitchView.new(@interpreter)      ,
            SourceView.new(@interpreter)  ,
            InstructionView.new(@interpreter)     ,
            StatusView.new(@interpreter)     ,
            RegistersView.new(@interpreter) ] )
  end

end

view = MainView.new()
view.draw.append_to($document.body)
