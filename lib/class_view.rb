class ClassView < ElementView
  def initialize clazz
    @clazz = clazz
  end

  def draw
    @element = div("li")
    add( "a" , @clazz.name ) << (ul = div("ul"))
    @clazz.object_layout.object_instance_names.each do |name|
      ul << (div("li") << div("a", name ))
    end
    @element
  end
end
