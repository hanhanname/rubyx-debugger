require_relative "html_converter"

class SourceView < ElementView

  def initialize interpreter
    @interpreter = interpreter
    @interpreter.register_event(:instruction_changed,  self)
  end

  def draw
    @text = div(".text")
    @ticker = div(".ticker")
    @element = div(".source_view") << div("h4.source" , "Class.Method") << @ticker << @text
    @element
  end

  def instruction_changed
    i = @interpreter.instruction
    return "" unless i
    update_method
    case i.source
    when AST::Node
      id = i.source.object_id
      if e = @text.at_css("#i#{id}")
        if (old = @text.at_css(".fade_in"))
          old.remove_class("fade_in")
        end
        e.add_class "fade_in"
      end
    when String
      @ticker.text = i.source
    else
      raise i.source.class.name
    end
  end

  def update_method
    i = @interpreter.instruction
    if i.is_a?(Register::FunctionReturn)
      object = @interpreter.get_register( i.register )
      #puts "Object #{object}"
      link = object.get_internal( i.index )
      #puts "Link #{link}"
      raise "No link method" unless link
      i = link
    end
    return unless (i.is_a? Register::Label)
    if i.is_method
      cl_name , method_name = *i.name.split(".")
      clazz = Register.machine.space.get_class_by_name cl_name
      method = clazz.get_instance_method( method_name)
    else
      return
    end
    @element.at_css(".source").text = i.name
    @text.inner_html = HtmlConverter.new.process( method.source )
  end

end
