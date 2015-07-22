

class BlockView

  include React::Component
  required_param :block, type: []


  def render
    div :class => :row  do
      block.each do |code| #should be block.codes.each
        code.to_s.br
      end
    end
  end
end
