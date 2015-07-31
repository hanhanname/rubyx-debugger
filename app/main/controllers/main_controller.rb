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
      init_classes
      init_blocks
      init_source
    end

    private
    def marker var
      return "W" if var.is_a? String
      var.class.name.split("::").last[0]
    end

    def init_machine
      machine = Virtual.machine.boot
      code = Ast::ExpressionList.new( [Ast::CallSiteExpression.new(:putstring, [] ,Ast::StringExpression.new("Hello again"))])
      Virtual::Compiler.compile( code , machine.space.get_main )
      machine.run_before "Register::CallImplementation"
      page._interpreter = { }
      @volt_app.interpreter.start machine.init
    end

    def init_classes
      page._classes!.clear
      Virtual.machine.space.classes.each do |name , claz|
        next if [:Kernel,:Module,:MetaClass,:BinaryCode].index name
        c = Volt::Model.new :name => name
        page._classes << c
      end
    end
    def init_blocks
      blocks = BlocksModel.new
      page._blocks = blocks
      @volt_app.interpreter.register_event(:instruction_changed,  blocks)
    end
    def init_source
      sources = SourceModel.new
      page._sources = sources
      @volt_app.interpreter.register_event(:instruction_changed,  sources)
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
