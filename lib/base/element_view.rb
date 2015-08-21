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

  def wrap_node_with node , wrapper
    node.replace_with wrapper
    node.append_to wrapper
  end

  def create_element class_or_id , text = nil
    @element = div( class_or_id , text)
  end

  def add class_or_id , tex = nil
    element = div( class_or_id , tex)
    element.append_to @element
    element
  end
end
