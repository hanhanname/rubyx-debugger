require_relative "html_converter"

class VoolView < ElementView

  def initialize interpreter
    @interpreter = interpreter
    @interpreter.register_event(:instruction_changed,  self)
  end

  def draw
    @text = div(".text")
    @ticker = div(".ticker")
    @element = div(".vool_view") << div("h4.source" , "Class.Method") << @ticker << @text
    @element
  end

  def instruction_changed
    i = @interpreter.instruction
    return "" unless i
    if i.is_a?(Risc::FunctionReturn)
      link = @interpreter.get_register( i.register )
      puts "Link #{link}:#{link.source}"
      raise "No link method" unless link
      i = link
    end
    method = nil
    case i.source
    when Mom::Instruction
      if(i.source.is_a?(Mom::SimpleCall))
        method = i.source.method
      end
      #TODO, give mom a source
    when Parfait::TypedMethod
      method = i.source
    when String
      return
    else
      raise "Unrecognized source #{i.source.class.name} for #{i}"
    end
    update_method(method) if method
  end

  def update_method(method)
    @text.inner_html = method.name
  end

end
