class ClassView < ElementView

  def initialize interpreter
    @interpreter = interpreter
    @classes = []
    Virtual.machine.space.classes.each do |name , claz|
      next if [:Kernel,:Module,:MetaClass,:BinaryCode].index name
      @classes << name
    end
    @classes.sort!
  end

  def variables(clas_model)
    layout = Virtual.machine.space.get_class_by_name(clas_model._name).object_layout
    vars = []
    layout.object_instance_names.each do |name|
      vars.push name
    end
    vars
  end

  def draw
    DOM do |dom|
      dom.div.classes do
        dom.h4 {"Classes"}
        dom.ul.nav! do
          @classes.each do |cl|
            dom.li do
              dom.a { cl }
            end
          end
        end
      end
    end
  end
  #             <a href="#">{{ clas._name }}</a>
  #             {{ unless variables(clas).empty? }}
  #               <ul>
  #                 {{variables(clas).each do |var| }}
  #                 <li>
  #                   <a href="#">{{var}}</a>
  #                 </li>
  #                 {{ end }}
  #               </ul>

end
