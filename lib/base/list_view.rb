require_relative "element_view"

class ListView < ElementView

  def initialize children
    @children = children
    @elements = []
  end

  # create a root node acording to the tag given (default div)
  # The tag name will be passed to the div function, so class and id may be set as well (see there)
  # draw all children and keep the elements as @elements
  # return (as per base class) the single root of the collection
  def draw root = "div"
    @element = div(root)
    @elements = @children.collect do | c |
      append_element c.draw
    end
    @element
  end

  # replace the child at index with the given one (second arg)
  # The child must be an ElementView , which will be rendered and
  # the old node will be replaces in the live dom
  def replace_at index , with
    old = @elements[index]
    @children[index] = with
    rendered = with.draw
    @elements[index] = rendered
    old.replace_with rendered
  end

  def append view
    @children << view
    rendered = view.draw
    @elements << rendered
    @element << rendered
  end
end
