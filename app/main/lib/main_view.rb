
require "salama"

require_relative "registers_view"
require_relative "object_view"
require_relative "space_view"

class MainView

  def initialize

    registers = RegisterView.new(max)

    ParseTask.parse(1).then do |result|
      is = Ast::Expression.from_basic(result)
      Virtual::Compiler.compile( is , Virtual.machine.space.get_main )
      Virtual.machine.run_before Virtual::Machine::FIRST_PASS
    end.fail do |error|
      raise "Error: #{error}"
    end
    space = SpaceView.new(max)


  end

end
