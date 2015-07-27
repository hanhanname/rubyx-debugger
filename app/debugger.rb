
require "register_view"
require "class_view"
require "source_view"
require "block_view"

class Debugger

  include React::Component
  required_param :machine , :type => Virtual::Machine
  define_state :interpreter  => Interpreter.new

  before_mount do
    code = Ast::ExpressionList.new( [Ast::CallSiteExpression.new(:putstring, [] ,Ast::StringExpression.new("Hello again"))])
    Virtual::Compiler.compile( code , machine.space.get_main )
    machine.run_before "Register::CallImplementation"
    interpreter.start machine.init
  end
  def render
    div.debugger_view do
      ClassView classes: machine.space.classes
      div.file_view do
        "Future Source code view"
      end
      SourceView  :interpreter => interpreter
      BlockView :interpreter => interpreter
      div.registers_view do
        interpreter.registers.each do |r , oid|
          RegisterView interpreter: interpreter , register: r
        end
      end
    end

  end
end
