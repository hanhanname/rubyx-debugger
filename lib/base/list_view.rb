require_relative "element_view"

# Listviews hold an array of elements and are responsible for drawing (and re-drawing them)
#
# A ListView hold the elements, but also the drawn html divs. You can change the element
# structure by adding/removing/replacing and the ListView will take care of redrawing the html
#
# A ListView is itself an ElementView so one can build recursive structures.
#
# Also one can easily change the root html element, or by deriving wrap or edit the resulting html
#
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
  # the old node will be replaced in the live dom
  def replace_at index , with
    old = @elements[index]
    @children[index] = with
    rendered = with.draw
    @elements[index] = rendered
    old.replace_with rendered
  end

  # remove the first child and element (from view)
  def remove_first
    remove_at 0
  end

  # remove both child and element at given position
  def remove_at index
     raise "insex out of bounds #{index} => #{@children.length}" if(index >= @children.length or index < 0)
     @children.delete_at( index )
     element = @elements.delete_at(index)
     element.remove
  end

  # remove all elements and views, basically resetting the list to empty
  def clear_view
    remove_first while( ! @children.empty? )
  end

  # append a View instnace to the children array
  # render it and append it to the html element
  # and keep a copy in @elements
  def append_view view
    @children << view
    rendered = view.draw
    @elements << rendered # add to internal array
    @element << rendered  # add to html children
    rendered
  end
end
