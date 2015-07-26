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
        last = @interpreter.instruction
        @interpreter.tick
    end
    return last
  end
  def test_first_branch
    was = @interpreter.block
    assert_equal Register::Branch , ticks(1).class
    assert was != @interpreter.block
  end
  def test_second
    assert_equal Register::LoadConstant ,  ticks(2).class
    assert_equal Parfait::Space ,  Virtual.machine.objects[ @interpreter.get_register(:r1)].class
    assert_equal :r1,  @interpreter.instruction.array.symbol
  end
  def test_third
    assert_equal Register::GetSlot , ticks(3).class
    assert @interpreter.get_register( :r3 )
    assert @interpreter.get_register( :r3 ).is_a? Integer
  end
  def test_fourth
    assert_equal Register::SetSlot ,  ticks(4).class
  end
  def test_fifth
    transfer = ticks 5
    assert_equal Register::RegisterTransfer ,  transfer.class
    assert_equal @interpreter.get_register(transfer.to) , @interpreter.get_register(transfer.from)
  end
  def test_sixth
    assert_equal Register::GetSlot ,  ticks(6).class
  end
  def test_seventh
    assert_equal Register::FunctionCall ,  ticks(7).class
  end
  def test_eighth
    assert_equal Register::SaveReturn ,  ticks(8).class
  end
  def test_ninth
    assert_equal Register::LoadConstant ,  ticks(9).class
  end

end
