
require "source_view"
require "instruction_view"

class BlockView

  include React::Component
  required_param :interpreter

  define_state :block

  before_mount do
    interpreter.register_event(:block_changed,  self)
    block! interpreter.block
  end

  def block_changed old , bl
    block! bl
  end

  def render
    return unless block
    div.row  do
      div.col_md_5 do
        SourceView  :source => block.codes.first.source
      end
      div.col_md_5 do
        h6 { "Block: #{block.name}"}
        block.codes.each do |code|
          InstructionView  :interpreter => interpreter , :instruction => code
        end
      end
      div.col_md_2 do
        button.btn.btn_default { "next" }.on(:click) { interpreter.tick }
      end
    end
  end
end
