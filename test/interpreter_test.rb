require_relative "helper"

class InterpreterTest < MiniTest::Test

  def setup
    Virtual.machine.boot
    code = Ast::ExpressionList.new( [Ast::CallSiteExpression.new(:putstring, [] ,Ast::StringExpression.new("Hello again"))])
    Virtual::Compiler.compile( code , Virtual.machine.space.get_main )
    Virtual.machine.run_before "Register::CallImplementation"
    @interpreter = Interpreter.new
    @interpreter.start Virtual.machine.init
  end

  def test_first
    @interpreter.tick
  end
end
