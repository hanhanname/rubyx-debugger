require_relative "ref_view"

class ObjectView < ListView

  def initialize interpreter , object_id
    @object_id = object_id
    @interpreter = interpreter
    @interpreter.register_event(:object_changed,  self)
    super( content_elements )
  end

  def draw
    @element = super("ul.nav!")
    prepend_element div("li" , "-------------------------")
    prepend_element div( "li" ) << div("span" ,  class_header(@object_id) )
    return @element
  end

  def object_changed reg , at
    puts "Object changed in #{reg}"
    for_object = @interpreter.get_register( reg )
    return unless for_object == @object_id
    puts "Object changed  #{for_object} , at #{at}"

  end

  def class_header(id)
    object = Virtual.machine.objects[id]
    clazz = object.class.name.split("::").last
    [clazz, id].join " : "
  end

  def content_elements
    object = Virtual.machine.objects[@object_id]
    fields = []
    if object and ! object.is_a?(String)
      object.get_instance_variables.each do |variable|
        f = object.get_instance_variable(variable)
        fields << RefView.new( variable , f.object_id )
      end
    end
    fields
  end

end
