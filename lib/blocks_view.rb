
class BlocksView < ListView

  def initialize interpreter
    @interpreter = interpreter
    @interpreter.register_event(:instruction_changed,  self)
    super([BlockView.new(@interpreter.block)])
    @method_name = method_name
  end

  def draw
    super()
    wrap_element div("div.block_view") << div("h4.method" , @method_name) << div("h4" , "Block" )
    return @element
  end

  def instruction_changed
    return if @interpreter.block.name == active_block_name
    @elements.last.at_css(".bright").remove_class("bright")
    append_view( BlockView.new(@interpreter.block) )
    remove_first if( @elements.length > 6)
    new_name = method_name
    return if new_name == @method_name
    @method_name = new_name
    @element.at_css(".method").text = method_name
  end

  def active_block_name
    @children.last.block.name
  end

  def block_name
    @interpreter.block ? @interpreter.block.name : ""
  end

  def method_name
    bl = @interpreter.block
    return "" unless bl
    return bl.method if bl.method.is_a? String
    "#{bl.method.for_class.name}.#{bl.method.name}"
  end
end

class BlockView < ElementView

  def initialize block
    @block = block
  end
  attr_reader :block

  def draw
    @element = div("div") << div("span.bright" , @block.name )
  end

end
