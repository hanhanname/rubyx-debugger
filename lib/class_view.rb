class ClassView < ListView

  def initialize

#    page._classes!.clear
    all = []
    Virtual.machine.space.classes.each do |name , claz|
      next if [:Kernel,:Module,:MetaClass,:BinaryCode].index name
      all << name
    end
    all.sort.each do |name|
#      c = Volt::Model.new :name => name
#      page._classes << c
    end
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
    div.classes do
      h4 {"Classes"}
      ul.nav do
      #{{page._classes.each do |clas| }}
        li do
          a { "me "}
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
      end
    end
  end

end
