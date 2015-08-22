require_relative "block_view"

class BlocksView < ListView

  def initialize interpreter
    @interpreter = interpreter
    @interpreter.register_event(:instruction_changed,  self)
    super([BlockView.new(@interpreter.block)])
  end

  def draw
    super()
    wrap_element div("div.block_view") << div("h4" , "Method #{method_name}") << div("h4" , "Block" )
    return @element
  end

  def instruction_changed
    return if @interpreter.block.name == active_block_name
    @elements.last.at_css(".bright").remove_class("bright")
    append( BlockView.new(@interpreter.block) )
    remove_first if( @elements.length > 5)
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
