class ElementView

  def initialize
    @element = nil
  end

  def draw
    raise "implement me to return an Element"
  end

  def create_element name_class
    name , clazz = name_class.split(".")
    name = "div" if name.empty?
    element = $document.create_element(name)
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

  def wrap_node_with node , wrapper
    node.replace_with wrapper
    node.append_to wrapper
  end

end
