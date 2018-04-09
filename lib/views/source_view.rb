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
    when Mom::Instruction
      @ticker.text = i.source.class.name
      # if e = @text.at_css("#i#{id}")
      #   if (old = @text.at_css(".fade_in"))
      #     old.remove_class("fade_in")
      #   end
      #   e.add_class "fade_in"
      # end
    when String
      @ticker.text = i.source
    when Risc::Instruction
      @ticker.text = i.source.to_s
    else
      raise "Unrecognized source #{i.source.class.name} for #{i}"
    end
  end

  def update_method
    i = @interpreter.instruction
    if i.is_a?(Risc::FunctionReturn)
      link = @interpreter.get_register( i.register )
      #puts "Link #{link}"
      raise "No link method" unless link
      i = link
    end
    return unless (i.is_a? Risc::Label)
    return unless i.is_method
    puts i.name
    return
    cl_t_name , method_name = *i.name.split(".")
    class_name = cl_t_name.split(" ").last.split("_").first
    clazz = Parfait.object_space.get_class_by_name class_name
    raise "No class for #{cl_name} , #{i.name}" unless clazz
    type = clazz.instance_type
    method = type.get_method( method_name )
    @element.at_css(".source").text = i.name
    @text.inner_html = HtmlConverter.new.process( method.source )
  end

end
