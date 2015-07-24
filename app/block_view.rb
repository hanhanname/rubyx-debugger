
require "source_view"

class BlockView

  include React::Component
  required_param :interpreter

  before_mount do
    interpreter.register_event(event: :block_changed, listener: self, callback: :block_changed)
  end

  def block_changed block
    block! block
  end

  def render
    div.row  do
      div.col_md_5 do
        SourceView  :source => interpreter.block.codes.first.source
      end
      div.col_md_5 do
        interpreter.block.codes.each do |code|
          code.to_s.br
        end
      end
      div.col_md_2 do
        button.btn.btn_default { "next" }.on(:click) { interpreter.tick }
      end
    end
  end
end
