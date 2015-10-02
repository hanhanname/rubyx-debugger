
require "opal"
require "opal-parser"


require 'browser'
require 'native'
require "salama"
require "salama-reader"
require "ast"
require "interpreter/interpreter"
require "base/list_view"
require_relative "classes_view"
require_relative "status_view"
require_relative "file_view"
require_relative "blocks_view"
require_relative "instruction_view"
require_relative "registers_view"
require_relative "code"

class MainView < ListView

  def initialize
    machine = Virtual.machine.boot

    # compile_main includes the parse
    # parsing generates an ast as seen below and then compiles it.
    # machine.compile_main "2 + 5"

    # so the code above is functionally equivalent to the one below, minus the parse
    # When the ast expression is given all works, so pretty sure it is the parse that fails

    Bosl::Compiler.compile( CODE , machine.space.get_main )

    machine.run_before "Register::CallImplementation"
    @interpreter = Interpreter::Interpreter.new
    @interpreter.start machine.init
    super( [ClassesView.new(@interpreter)      ,
            FileView.new                     ,
            BlocksView.new(@interpreter)     ,
            InstructionView.new(@interpreter)     ,
            StatusView.new(@interpreter)     ,
            RegistersView.new(@interpreter) ] )
  end

end

view = MainView.new()
view.draw.append_to($document.body)
