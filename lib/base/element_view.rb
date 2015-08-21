class ElementView

  def initialize
    @element = nil
  end

  def draw
    raise "implement me to return an Element"
  end

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

  def add class_or_id , tex = nil
    element = div( class_or_id , tex)
    element.append_to @element
    element
  end
end
