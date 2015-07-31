
require "instruction_view"

class BlockView


  include React::Component
  required_param :interpreter

  define_state :block => []
  define_state :block_name => ""

  before_mount do
    interpreter.register_event(:instruction_changed,  self)
    update_block
  end

  def update_block
    return unless interpreter.instruction
    block_name! interpreter.block.name
    codes = interpreter.block.codes.dup
    slice = codes.index(interpreter.instruction) #- 1
    codes.shift( slice ) if slice >= 0
    codes.pop while(codes.length > 4)
    block! codes
  end

  def instruction_changed
    update_block
  end

  def render
    return unless block
    div.block_view do
      div do
        h4 { method_name}
        h4 {"Block: #{block_name}"}
      end
      block.each do |code|
        InstructionView  :interpreter => interpreter , :instruction => code
      end
    end
  end

  def method_name
    bl = interpreter.block
    return bl.method if bl.method.is_a? String
    "#{bl.method.for_class.name}.#{bl.method.name}"
  end
end
