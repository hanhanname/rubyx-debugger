class SourceView < ElementView

  def initialize interpreter
    @interpreter = interpreter
    @interpreter.register_event(:instruction_changed,  self)
  end

  def draw
    @text = div
    @element = div(".source_view") << div("h4" ,"Future") << @text
    @element
  end

  def instruction_changed
    @text.text = source
  end

  def source
    i = @interpreter.instruction
    return "" unless i
    case i.source
    when AST::Node
      i.source.to_s
    when String
      "String " + i.source
    else
      raise i.source.class.name
    end

  end

end
