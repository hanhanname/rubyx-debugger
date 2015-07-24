
require "eventable"

class Interpreter
  include Eventable

  attr_accessor :instruction
  attr_accessor :block
  attr_accessor :registers

  def initialize
    @registers = Hash[(0...12).collect{|i| ["r#{i}" , "undefined"]}]
  end

  def start block
    set_block  block
  end
  def set_block block
    return if @block == block
    old = @block
    @block = block
     trigger(:block_changed , old , block)
     set_instruction block.codes.first
  end
  def set_instruction i
    return if @instruction == i
    old = @instruction
    @instruction = i
    trigger(:instruction_changed, old , i)
  end
  def tick
    name = @instruction.class.name.split("::").last
    fetch = send "execute_#{name}"
    return unless fetch
    get_next_intruction
  end

  def execute_Branch
    target = @instruction.to
    set_block target
  end
end
