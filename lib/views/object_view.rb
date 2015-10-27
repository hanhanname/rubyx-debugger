require_relative "ref_view"

class ObjectView < ListView

  # z is the z-index

  def initialize  object_id , interpreter = nil , z = nil
    @object_id = object_id
    @z = z
    @interpreter = interpreter
    @interpreter.register_event(:object_changed,  self) if interpreter
    super( content_elements )
  end

  def draw
    @element = super(@interpreter ? "ul.nav!" : "ul")
    prepend_element div("li" , "-------------------------")
    prepend_element div( "li" ) << div("span" ,  class_header(@object_id) )
    return @element
  end

  def object_changed reg , at
    at = at - 1 #take the layout off
    #puts "Object changed in #{reg}"
    for_object = @interpreter.get_register( reg )
    return unless for_object == @object_id
    #puts "Object changed  #{for_object} , at #{at}"
    object = Register.machine.objects[@object_id]
    raise "error #{@object_id} , #{at}"  unless object and ! object.is_a?(String)
    variable = object.get_instance_variables.get(at)
    if(variable)
      f = object.get_instance_variable(variable)
    else
      at += 1 # add layout back
      variable = at.to_s
      f = object.internal_object_get(at)
    end
    #puts "got var name #{variable}#{variable.class} for #{at}, #{f}"
    view = RefView.new( variable , f.object_id , @z )
    if( @children[at] )
      replace_at(at , view)
    else
      append_view(view)
    end
  end

  def class_header(id)
    object = Register.machine.objects[id]
    clazz = object.class.name.split("::").last
    [clazz, id].join " : "
  end

  def content_elements
    object = Register.machine.objects[@object_id]
    fields = []
    if object and ! object.is_a?(String)
      fields << RefView.new( "layout" , object.get_layout.object_id , @z )
      object.get_instance_variables.each do |variable|
        f = object.get_instance_variable(variable)
        fields << RefView.new( variable , f.object_id , @z )
      end
      if( object.is_a?(Parfait::List) )
        index = 1
        object.each do | o , i|
          fields << RefView.new( index.to_s , o.object_id , @z )
          index += 1
        end
      end
    end
    fields
  end

end
