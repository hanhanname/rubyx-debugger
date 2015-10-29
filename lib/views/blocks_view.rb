
class BlocksView < ListView

  def initialize interpreter
    @interpreter = interpreter
    @interpreter.register_event(:instruction_changed,  self)
    @interpreter.register_event(:state_changed,  self)
    show = []
    show << LabelView.new(@interpreter.instruction) if @interpreter.instruction.is_a?(Register::Label)
    super(show)
  end

  def draw
    super()
    wrap_element div("div.labels_view") << div("h4" , "Method + Block " ) << div("h4.method" , @method_name)
    return @element
  end

  def instruction_changed
    return unless @interpreter.instruction.is_a?(Register::Label)
    if @children.last
      return if @interpreter.instruction.object_id == @children.last.label.object_id
      @elements.last.at_css(".bright").remove_class("bright")
    end
    append_view( LabelView.new(@interpreter.instruction) )
    remove_first if( @elements.length > 6)
  end

  def state_changed old , new_s
    return unless new_s == :running
    clear_view
  end

end

class LabelView < ElementView

  def initialize label
    @label = label
  end
  attr_reader :label

  def draw
    @element = div("div") << div("span.bright" , label_name )
  end

  def label_name
    return @label if @label.is_a? String
    @label.name
  end

end
