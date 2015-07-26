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
  def test_branch
    was = @interpreter.block
    assert_equal Register::Branch , ticks(1).class
    assert was != @interpreter.block
  end
  def test_load
    assert_equal Register::LoadConstant ,  ticks(2).class
    assert_equal Parfait::Space ,  Virtual.machine.objects[ @interpreter.get_register(:r1)].class
    assert_equal :r1,  @interpreter.instruction.array.symbol
  end
  def test_get
    assert_equal Register::GetSlot , ticks(3).class
    assert @interpreter.get_register( :r3 )
    assert @interpreter.get_register( :r3 ).is_a? Integer
  end
  def test_transfer
    transfer = ticks 5
    assert_equal Register::RegisterTransfer ,  transfer.class
    assert_equal @interpreter.get_register(transfer.to) , @interpreter.get_register(transfer.from)
  end
  def test_call
    assert_equal Register::FunctionCall ,  ticks(7).class
    assert @interpreter.link
  end
  def test_save
    done = ticks(8)
    assert_equal Register::SaveReturn ,  done.class
    assert @interpreter.get_register done.register.symbol
  end

  def test_chain
    ["Branch" , "LoadConstant" , "GetSlot" , "SetSlot" , "RegisterTransfer" ,
     "GetSlot" , "FunctionCall" , "SaveReturn" , "LoadConstant"  , "SetSlot" ,
     "GetSlot" ,  "GetSlot" , "SetSlot" , "LoadConstant" , "SetSlot" ,
     "RegisterTransfer" ,  "GetSlot" ,  "FunctionCall" , "SaveReturn" ,
     "RegisterTransfer" , "Syscall"].each_with_index do |name , index|
      got = ticks(1)
      assert got.class.name.index(name) , "Wrong class for #{index}, expect #{name} , got #{got}"
    end
  end

  def test_putstring
    done = ticks(21)
    assert_equal Register::Syscall ,  done.class
    assert_equal "Hello again" , @interpreter.stdout  
  end

end
