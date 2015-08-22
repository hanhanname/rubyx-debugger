
class ObjectView < ElementView

  def initialize interpreter , object_id
    @object_id = object_id
    @interpreter = interpreter
    @interpreter.register_event(:object_changed,  self)
  end

  def draw
    # todo, remove the DOM use
    DOM do |dom|
      dom.ul.nav! do # :sid => @object_id
        dom.li do
          dom.span {class_header(@object_id)}
        end
        dom.li { "&nbsp;&nbsp;-------------------------"}
        content(@object_id).each do |con3|
          dom.li do
            dom.a(:href => "#") { con3[0]}
          end
        end
      end
    end
  end

  def object_changed reg
    puts "Object changed in #{reg}"
    for_object = @interpreter.get_register( reg )
    return unless for_object == @object_id
    puts "Object changed  #{for_object}"
    calc_fields
  end

  def marker id
    var = Virtual.machine.objects[id]
    if var.is_a? String
      str "Wo"
    else
      str = var.class.name.split("::").last[0,2]
    end
    str + " : #{id.to_s}"
  end

  def class_header(id)
    object = Virtual.machine.objects[id]
    return "" unless object
    clazz = object.class.name.split("::").last
    "#{clazz}:#{id}"
  end

  def content(id)
    object = Virtual.machine.objects[id]
    fields = []
    if object and ! object.is_a?(String)
      object.get_instance_variables.each do |variable|
        f = object.get_instance_variable(variable)
        fields << ["#{variable} : #{marker(f.object_id)}" , f.object_id]
      end
    end
    fields
  end

end
