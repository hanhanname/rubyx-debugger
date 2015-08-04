# By default Volt generates this controller for your Main component
require "salama"
require "interpreter/interpreter"


module Main
  class MainController < Volt::ModelController

    def initialize *args
      super(*args)
      @volt_app.class.attr_accessor :interpreter
      @volt_app.interpreter = Interpreter::Interpreter.new
    end

    def index
      init_machine
    end

    private

    def init_machine
      machine = Virtual.machine.boot
      code = Ast::OperatorExpression.new("+", Ast::IntegerExpression.new(2),Ast::IntegerExpression.new(5))
      Virtual::Compiler.compile( code , machine.space.get_main )
      machine.run_before "Register::CallImplementation"
      page._interpreter = { }
      @volt_app.interpreter.start machine.init
    end

    # The main template contains a #template binding that shows another
    # template.  This is the path to that template.  It may change based
    # on the params._component, params._controller, and params._action values.
    def main_path
      "#{params._component || 'main'}/#{params._controller || 'main'}/#{params._action || 'index'}"
    end

    # Determine if the current nav component is the active one by looking
    # at the first part of the url against the href attribute.
    def active_tab?
      url.path.split('/')[1] == attrs.href.split('/')[1]
    end
  end
end
