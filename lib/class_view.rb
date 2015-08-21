class ClassView < ListView

  def initialize interpreter
    @interpreter = interpreter
    @classes = []
    Virtual.machine.space.classes.each do |name , claz|
      next if [:Kernel,:Module,:MetaClass,:BinaryCode].index name
      @classes << claz
    end
    @classes.sort! {|a,b| a.name <=> b.name }
  end

  def draw
    create_element(".classes") << div("h4" , "Classes")
    list = add("ul.nav!")

    @classes.each do |cl|
      list << (div("li") <<
                (div( "a" , cl.name ) <<
                    (ul = div("ul"))))
      cl.object_layout.object_instance_names.each do |name|
        ul << (div("li") << div("a", name ))
      end
    end
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
