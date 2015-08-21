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

    DOM do |dom|
      dom.div.classes do
        dom.h4 {"Classes"}
        dom.ul.nav! do
          @classes.each do |cl|
            dom.li do
              dom.a { cl.name }
              dom.ul do
                cl.object_layout.object_instance_names.each do |name|
                  dom.li do
                    dom.a{  name }
                  end
                end
              end
            end
          end
        end
      end
    end
  end

end
