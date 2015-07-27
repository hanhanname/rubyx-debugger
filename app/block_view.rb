
require "source_view"
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
        h4 {"Block: #{block_name}"}
        button.btn.btn_default { "next" }.on(:click) { interpreter.tick }
      end
      block.each do |code|
        InstructionView  :interpreter => interpreter , :instruction => code
      end
    end
  end
end
