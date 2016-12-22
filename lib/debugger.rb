
require "opal"
require "opal-parser"

require "logger"
require 'browser'
require 'browser/http'
require 'native'
require "salama"
require "ast"
require "register/interpreter"
# the base, our own litle framework, allows for child and parent views and handles updates
require "base/list_view"
# each seperate view is in it's own class.
require "views/switch_view"
require "views/status_view"
require "views/source_view"
require "views/instruction_view"
require "views/registers_view"
class Bignum
end
class String
  def codepoints
    arr = []
    one = nil
    self.each_byte do |c|
      if( one )
        arr << (one + c * 256)
        one = nil
      else
        one = c
      end
    end
    arr
  end
end
class MainView < ListView
  include AST::Sexp

  def initialize
    machine = Register.machine.boot
    code = s(:statements, s(:return, s(:operator_value, :+, s(:int, 5), s(:int, 7))))
    Typed.compile( code  )
    machine.collect
    @interpreter = Register::Interpreter.new
    super( [SwitchView.new(@interpreter)      ,
            SourceView.new(@interpreter)  ,
            InstructionView.new(@interpreter)     ,
            StatusView.new(@interpreter)     ,
            RegistersView.new(@interpreter) ] )
  end

end

view = MainView.new()
view.draw.append_to($document.body)
