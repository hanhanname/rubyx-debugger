require_relative "class_view"

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
