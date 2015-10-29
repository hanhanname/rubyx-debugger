class SourceView < ElementView

  def initialize interpreter
    @interpreter = interpreter
    @interpreter.register_event(:instruction_changed,  self)
  end

  def draw
    @text = div
    @ticker = div
    @element = div(".source_view") << div("h4" ,"Future") << @ticker << @text
    @element
  end

  def instruction_changed
    i = @interpreter.instruction
    return "" unless i
    case i.source
    when AST::Node
      @text.text = i.source.to_s
      @ticker.text = ""
    when String
      @ticker.text = i.source
    else
      raise i.source.class.name
    end

  end

end
