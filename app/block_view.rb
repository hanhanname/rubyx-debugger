
require "source_view"

class BlockView

  include React::Component
  required_param :block, type: Virtual::Block

  define_state :source

  def render
    div.row  do
      div.col_md_6 do
        SourceView  :source => block.codes.first.source
      end
      div.col_md_6 do
        block.codes.each do |code| #should be block.codes.each
          code.to_s.br
        end
      end
    end
  end
end
