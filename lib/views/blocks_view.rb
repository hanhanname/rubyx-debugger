
class BlocksView < ListView

  def initialize interpreter
    @interpreter = interpreter
    @interpreter.register_event(:instruction_changed,  self)
    super([BlockView.new(@interpreter.block)])
    @method_name = method_name
  end

  def draw
    super()
    wrap_element div("div.block_view") << div("h4" , "Method + Block " ) << div("h4.method" , @method_name)
    return @element
  end

  def instruction_changed
    new_name = method_name
    unless new_name == @method_name
      @method_name = new_name
      @element.at_css(".method").text = method_name
    end
    return if @interpreter.block.object_id == @children.last.block.object_id
    @elements.last.at_css(".bright").remove_class("bright")
    append_view( BlockView.new(@interpreter.block) )
    remove_first if( @elements.length > 6)
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
    @element = div("div") << div("span.bright" , block_name )
  end

  def method_name
    return @block.method if @block.method.is_a? String
    @block.method.name
  end

  def block_name
    return @block if @block.is_a? String
    "#{method_name}.#{@block.name}"
  end

end
