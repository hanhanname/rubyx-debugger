
class Debugger

  include React::Component
#  required_param :machine
  define_state  :machine => Virtual.machine.boot

  before_mount do
    code = Ast::ExpressionList.new [Ast::CallSiteExpression.new( "putstring", [], Ast::StringExpression.new("Hello again"))]
    Virtual::Compiler.compile( code , machine.space.get_main )
    machine.run_before "Register::CallImplementation"
  end

  def initialize
    @interpreter = Interpreter.new
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
            div.col_md_4 do
              "Future two"
            end
            div.col_md_4 do
              BlockView block: [ "block 1" , "block 2"]
            end
          end
          RegisterView registers: @interpreter.registers
        end
      end
    end

  end
end
