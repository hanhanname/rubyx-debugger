require_relative "element_view"

class ListView < ElementView

  def initialize children
    @children = children
    @elements = []
  end

  def root
    "div"
  end

  def draw on
    @element = div(self.root)
    @elements = @children.collect do | c |
      elem = c.draw(@element)
      elem.append_to(@element)
      elem
    end
    @element
  end

end
