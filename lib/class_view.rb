class ClassView < ElementView
  def initialize clazz
    @clazz = clazz
  end

  def draw
    @element = div("li") << div( "a" , @clazz.name ) << (ul = div("ul"))
    @clazz.object_layout.object_instance_names.each do |name|
      ul << (div("li") << div("a", name ))
    end
    @element.style["z-index"] = 20
    @element
  end
end
