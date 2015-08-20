
require 'browser'
require 'native'
require "salama"
require "interpreter/interpreter"
require "list_view"
require_relative "class_view"
require_relative "status_view"
#require_relative "registers_view"
#require_relative "object_view"
#require_relative "space_view"

class MainView < ListView

  def initialize
    machine = Virtual.machine.boot

    # compile_main includes the parse
    # parsing generates an ast as seen below and then compiles it.
    # machine.compile_main "2 + 5"

    # so the code above is functionally equivalent to the one below, minus the parse
    # When the ast expression is given all works, so pretty sure it is the parse that fails

    code = Ast::OperatorExpression.new("+", Ast::IntegerExpression.new(2),Ast::IntegerExpression.new(5))
    Virtual::Compiler.compile( code , machine.space.get_main )

    machine.run_before "Register::CallImplementation"
    @interpreter = Interpreter::Interpreter.new
    super( [ClassView.new(@interpreter) , StatusView.new(@interpreter)] )
  end

  def draww
    node = DOM { |m|
       Kernel.puts "DOM #{self.class}"
        m.div.info {
          Kernel.puts "div #{self.class}" ; ""
          m.span.red @interpreter.state
        }
      }
      node.append_to(@parent)
  end

  def no

    body = Native(`window.document.body`)
    # bit of a hack as it assumes index's structure
    html_con = body.firstElementChild
    html_con.insertBefore renderer.view , html_con.lastElementChild

    registers = RegisterView.new(height - 150)
    @canvas.add_child registers

    space = SpaceView.new
    @container.add_child space

    animate = Proc.new do
      `requestAnimationFrame(animate)`
      registers.draw_me
      space.draw_me
      renderer.render @container
    end
    animate.call

  end

end
