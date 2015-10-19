
class ClassesView < ListView

  def initialize interpreter
    @interpreter = interpreter
    classes = []
    Virtual.machine.space.classes.each do |name , claz|
      next if [:Kernel,:Module,:MetaClass,:BinaryCode].index name
      classes << claz
    end
    classes.sort! {|a,b| a.name <=> b.name }
    super( classes.collect{|c| ClassView.new(c)})
  end

  def draw
    super()
    wrap_element div("ul.nav!")
    wrap_element( div(".classes") << div("h4" , "Classes") )
    return @element
  end

end

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
