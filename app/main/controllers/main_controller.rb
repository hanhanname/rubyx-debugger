# By default Volt generates this controller for your Main component
require "salama"
require "interpreter/interpreter"


module Main
  class MainController < Volt::ModelController
    def index
      init_machine
      init_classes
      init_registers
      init_blocks
      init_source
    end

    def tick
      @interpreter.tick
      update_interpreter
    end
    def update_interpreter
      page._interpreter._clock = @interpreter.clock
      page._interpreter._state = @interpreter.state
      page._interpreter._stdout = @interpreter.stdout
      page._interpreter._link = @interpreter.link.to_s
      page._method_name = method_name
      page._block_name = @interpreter.block ? @interpreter.block.name : " "
    end
    private
    def marker var
      return "W" if var.is_a? String
      var.class.name.split("::").last[0]
    end
    def method_name
      bl = @interpreter.block
      return " " unless bl
      return bl.method if bl.method.is_a? String
      "#{bl.method.for_class.name}.#{bl.method.name}"
    end

    def init_machine
      machine = Virtual.machine.boot
      code = Ast::ExpressionList.new( [Ast::CallSiteExpression.new(:putstring, [] ,Ast::StringExpression.new("Hello again"))])
      Virtual::Compiler.compile( code , machine.space.get_main )
      machine.run_before "Register::CallImplementation"
      @interpreter = Interpreter::Interpreter.new
      page._interpreter = { }
      update_interpreter
      @interpreter.start machine.init
    end
    def init_registers
      page._registers!.clear
      @interpreter.registers.each do |reg , val|
        model = RegisterModel.new( :name => reg , :value => val)
        page._registers <<  model
        @interpreter.register_event(:register_changed,  model)
        @interpreter.register_event(:object_changed,  model)
        model.register_changed( reg , nil , @interpreter.registers[reg])
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
    def init_source
      sources = SourceModel.new
      page._sources = sources
      @interpreter.register_event(:instruction_changed,  sources)
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
