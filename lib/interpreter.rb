
require "eventable"

class Interpreter
  include Eventable

  attr_accessor :instruction
  attr_accessor :link
  attr_accessor :block
  attr_accessor :registers

  def initialize
    @registers = {}
    (0...12).each do |r|
      set_register "r#{r}".to_sym , "undefined"
    end
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
    puts "next up #{i.class}"
    old = @instruction
    @instruction = i
    trigger(:instruction_changed, old , i)
  end

  def get_register( reg )
    reg = reg.symbol if reg.is_a? Register::RegisterReference
    raise "Not a register #{reg}" unless Register::RegisterReference.look_like_reg(reg)
    @registers[reg]
  end

  def set_register reg , val
    old = get_register( reg ) # also ensures format
    return if old === val
    reg = reg.symbol if reg.is_a? Register::RegisterReference
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

  def object_for reg
    id = get_register(reg)
    object = Virtual.machine.objects[id]
  end
  # Instruction interpretation starts here
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

  def execute_GetSlot
    object = object_for( @instruction.array )
    value = object.internal_object_get( @instruction.index )
    value = value.object_id unless value.is_a? Integer
    set_register( @instruction.register , value )
    true
  end

  def execute_SetSlot
    object = object_for( @instruction.register )
    value = object_for( @instruction.array )
    object.internal_object_set( @instruction.index , value )
    true
  end

  def execute_RegisterTransfer
    value = get_register @instruction.from
    set_register @instruction.to , value
    true
  end

  def execute_FunctionCall
    @link = [@block , @instruction]
    next_block = @instruction.method.source.blocks.first
    set_block next_block
    false
  end

  def execute_SaveReturn
    object = object_for @instruction.register
    object.internal_object_set @instruction.index , @link
    true
  end

end
