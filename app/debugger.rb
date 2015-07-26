
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
    div.container do
      div.row do
        div.col_md_1 do
          ClassView classes: machine.space.classes
        end
        div.col_md_11 do
          div.row do
            div.col_md_4 do
              "Future one"
            end
            div.col_md_8 do
              BlockView interpreter: interpreter
            end
          end
          div.row do
            interpreter.registers.each do |r , oid|
              div.col_md_1 do
                RegisterView interpreter: interpreter , register: r
              end
            end
          end
        end
      end
    end

  end
end
