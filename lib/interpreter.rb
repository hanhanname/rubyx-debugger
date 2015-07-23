
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
    @block = block
    trigger(:block, block)
    set_instruction block.codes.first
  end
  def set_instruction i
    return if @instruction == i
    @instruction = i
    trigger(:instruction, i)
  end
  def tick
    name = @instruction.class.name.split("::").last
    send "execute_#{name}"
  end

end
