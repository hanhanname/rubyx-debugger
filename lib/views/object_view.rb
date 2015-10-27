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
    prepend_element div( "li" ) << div("span" ,  class_header(@object_id) )
    return @element
  end

  def object_changed reg , at
    #puts "Object changed in #{reg} , at #{at}"
    for_object = @interpreter.get_register( reg )
    return unless for_object == @object_id
    #puts "Object changed  #{for_object} , at #{at}"
    object = Register.machine.objects[@object_id]
    raise "error #{@object_id} , #{at}"  unless object and ! object.is_a?(String)
    variable = object.get_instance_variables.get(at)
    if(variable)
      f = object.get_instance_variable(variable)
    else
      variable = (at - object.class.get_length_index).to_s
      f = object.internal_object_get(at)
    end
    #puts "got var name #{variable}#{variable.class} for #{at}, #{f}"
    view = RefView.new( variable , oid(f) , @z )
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
    fields = [ConstantView.new("li" , "-------------------------")]
    if object and ! object.is_a?(String)
      object.get_instance_variables.each do |variable|
        f = object.get_instance_variable(variable)
        fields << RefView.new( variable , oid(f) , @z )
      end
      if( object.is_a?(Parfait::Indexed) )
        index = 1
        object.each do | o|
          fields << RefView.new( index.to_s , oid(o) , @z )
          index += 1
        end
      end
    end
    fields
  end

  def oid o
    return o if o.is_a? Fixnum
    return o.object_id
  end
end
