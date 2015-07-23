
class Debugger

  include React::Component
  required_param :machine , :type => Virtual::Machine
  define_state :interpreter  => Interpreter.new

  before_mount do
    code = Ast::ExpressionList.new( [Ast::CallSiteExpression.new(:putstring, [] ,Ast::StringExpression.new("Hello again"))])
    Virtual::Compiler.compile( code , machine.space.get_main )
    machine.run_before "Register::CallImplementation"
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
              BlockView block: machine.init
            end
          end
          RegisterView registers: interpreter.registers
        end
      end
    end

  end
end
