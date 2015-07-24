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

  def ticks num
    last = nil
    num.times do
      last = @interpreter.tick
    end
    return last
  end
  def test_takes_branch
    was = @interpreter.block
    ticks 1
    assert was != @interpreter.block
  end
  def test_second
    ticks 2
    assert_equal Parfait::Space ,  Virtual.machine.objects[ @interpreter.get_register(:r1)].class
    assert_equal Register::GetSlot ,  @interpreter.instruction.class
    assert_equal :r1,  @interpreter.instruction.array.symbol
  end
  def test_third
    assert ticks 4
  end
end
