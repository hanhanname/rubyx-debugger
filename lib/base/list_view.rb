require_relative "element_view"

class ListView < ElementView

  def initialize children
    @children = children
    @elements = []
  end

  # can be overriden to return a string that will be passed to div to create the root
  # element for the list. See "div" in ElementView for possible strings
  def root
    "div"
  end

  # create a root node acording to the "root" function (default div)
  # draw all children and keep the elements as @elements
  # return (as per base class) the single root of the collection
  def draw
    @element = div(self.root)
    @elements = @children.collect do | c |
      add_element c.draw
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
