
require "eventable"

class Interpreter
  include Eventable

  attr_accessor :instruction
  attr_accessor :block
  attr_accessor :registers

  def initialize
    @registers = Hash[(0...12).collect{|i| ["r#{i}" , "undefined"]}]
  end

  def start bl
    set_block  bl
  end

  def set_block bl
    return if @block == bl
    raise "Error, nil block" unless bl
    old = @block
    @block = bl
     trigger(:block_changed , old , bl)
     set_instruction bl.codes.first
  end

  def set_instruction i
    return if @instruction == i
    raise "Error, nil instruction" unless i
    old = @instruction
    @instruction = i
    trigger(:instruction_changed, old , i)
  end

  def get_register( reg )
    reg = reg.symbol if  reg.is_a? Register::RegisterReference
    raise "Not a register #{reg}" unless Register::RegisterReference.look_like_reg(reg)
    @registers[reg]
  end

  def set_register reg , val
    old = get_register( reg ) # also ensures format
    return if old === val
    @registers[reg] = val
    trigger(:register_changed, reg ,  old , val)
  end

  def tick
    name = @instruction.class.name.split("::").last
    fetch = send "execute_#{name}"
    return unless fetch
    fetch_next_intruction
  end

  def fetch_next_intruction
    if(@instruction != @block.codes.last)
      set_instruction @block.codes[  @block.codes.index(@instruction)  + 1]
    else
      next_b = @block.method.source.blocks.index(@block) + 1
      set_block @block.method.source.blocks[next_b]
    end
  end
  def execute_Branch
    target = @instruction.block
    set_block target
    false
  end
  def execute_LoadConstant
    to = @instruction.register
    value = @instruction.constant.object_id
    set_register( to , value )
    true
  end
end
