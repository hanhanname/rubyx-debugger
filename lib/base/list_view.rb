require_relative "element_view"

class ListView < ElementView

  def initialize children
    @children = children
    @elements = []
    @container_element = nil
  end

  def root
    "div"
  end

  def draw on
    @container_element = create_element(self.root)
    @elements = @children.collect do | c |
      elem = c.draw(@container_element)
      elem.append_to(@container_element)
      elem
    end
    @container_element
  end

end
