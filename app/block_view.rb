
require "source_view"

class BlockView

  include React::Component
  required_param :interpreter


  def render
    div.row  do
      div.col_md_6 do
        SourceView  :source => interpreter.block.codes.first.source
      end
      div.col_md_6 do
        interpreter.block.codes.each do |code|
          code.to_s.br
        end
      end
    end
  end
end
