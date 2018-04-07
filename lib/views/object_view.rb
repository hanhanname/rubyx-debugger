require_relative "ref_view"

class ObjectView < ListView

  # z is the z-index

  def initialize  object , interpreter = nil , z = nil
    @object = object
    @z = z
    @interpreter = interpreter
    @interpreter.register_event(:object_changed,  self) if interpreter
    super( content_elements )
  end

  def draw
    @element = super(@interpreter ? "ul.nav!" : "ul")
    prepend_element div( "li" ) << div("span" ,  class_header )
    return @element
  end

  def object_changed( reg , at)
    #puts "Object changed in #{reg} , at #{at}"
    for_object = @interpreter.get_register( reg )
    return unless for_object == @object
    #puts "Object changed  #{for_object} , at #{at}"
    variable = @object.get_instance_variables.get(at)
    if(variable)
      f = @object.get_instance_variable(variable)
    else
      variable = at.to_s
      f = @object.get_internal_word(at)
    end
    #puts "got var name #{variable}#{variable.class} for #{at}, #{f}"
    view = RefView.new( variable , f , @z )
    if( @children[at] )
      replace_at(at , view)
    else
      append_view(view)
    end
  end

  def class_header
    clazz = @object.class.name.split("::").last
    [clazz, @object.object_id.to_s(16)].join " : "
  end

  def content_elements
    fields = [ConstantView.new("li" , "---------------------------------")]
    object = @object
    if object and ! object.is_a?(String)
      object.get_instance_variables.each do |variable|
        f = object.get_instance_variable(variable)
        fields << RefView.new( variable , f , @z )
      end
      if( object.is_a?(Parfait::List) )
        index = 1
        object.each do | o|
          fields << RefView.new( index.to_s , o , @z )
          index += 1
        end
      end
      if( object.is_a?(Parfait::Integer) )
        fields << RefView.new( 3.to_s , object.value , @z )
      end
      if( object.is_a?(Parfait::Word) )
        fields << RefView.new( 3.to_s , object.to_string , @z )
      end
    end
    fields
  end

end
