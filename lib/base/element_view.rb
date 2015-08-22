class ElementView

  def initialize
    @element = nil
  end

  #abstract function that should return the single element that is being represented
  # the element is also stored in @element
  def draw
    raise "implement me to return an Element"
  end

  # helper function to create an element with possible classes, id and text
  # The first argument is a bit haml inspired, so "tagname.classname" is the format
  # but if tagname is ommited it will default to div
  # also several classnames may be given
  # if one of the names ends in a ! (bang) it will be assigned as the id
  # second argument is optional, but if given will be added as text (content) to the newly
  # created Element
  # return the new Element, which is not linked into the dom at that point (see << and add*)
  def div name_class , text = nil
    name , clazz = name_class.split(".")
    name = "div" if name.empty?
    element = $document.create_element(name)
    element.text = text if text
    return element unless clazz
    if( clazz.is_a? Array )
      clazz.each { |c| add_class_or_id( element , cl )}
    else
      add_class_or_id element , clazz
    end
    element
  end

  def add_class_or_id element , class_or_id
    return element unless class_or_id
    if class_or_id[-1] == "!"
      element.id = class_or_id[0 ... -1]
    else
      element.add_class class_or_id
    end
    element
  end

  # wrap the @element variable with the given element
  # so if wrapper == <h4/> the new @element will be <h4> old @element </h4>
  # return the new @element, which is wrapper
  def wrap_element wrapper
    @element = wrap_node_with @element , wrapper
  end

  #wrap the given node with the wappper, so for a div wrapper and a button node
  # the result will be <div> <button>hwatever was in there</button> <div>
  def wrap_node_with node , wrapper
    node.replace_with(wrapper) if node.parent
    wrapper << node
  end

  # add the given element to the @element, at the end
  # return the div that was passed in  (use << to return the @element)
  def append_element div
    @element << div
    div
  end

  # add the given element to the @element , at the front
  # return the div that was passed in  (use >> to return the @element)
  def prepend_element div
    @element >> div
    div
  end

  # create a new element with class and possibly text
  # add that new element to the @element
  # return the newly created element
  def add class_or_id , tex = nil
    append_element div( class_or_id , tex)
  end


end
