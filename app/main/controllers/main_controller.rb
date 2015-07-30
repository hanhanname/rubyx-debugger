# By default Volt generates this controller for your Main component
require "salama"
require_relative "interpreter"


module Main
  class MainController < Volt::ModelController
    def index
      init_machine
      init_classes
      init_registers
      init_blocks
    end

    def about
      # Add code for when the about view is loaded
    end

    private
    def init_machine
      machine = Virtual.machine.boot
      machine.run_before "Register::CallImplementation"
      code = Ast::ExpressionList.new( [Ast::CallSiteExpression.new(:putstring, [] ,Ast::StringExpression.new("Hello again"))])
      Virtual::Compiler.compile( code , machine.space.get_main )
      @interpreter = Interpreter.new
      @interpreter.start machine.init
    end
    def init_registers
      page._registers!.clear
      @interpreter.registers.each do |reg , val|
        page._registers <<  RegisterModel.new( :name => reg , :value => val)
      end
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
      @interpreter.register_event(:instruction_changed,  blocks)
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
