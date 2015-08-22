#require_relative "block_view"
require_relative "base/constant_view"

class BlocksView < ListView

  def initialize interpreter
    @interpreter = interpreter
    @interpreter.register_event(:instruction_changed,  self)
    super([ConstantView.new("div" , "Block name1") , ConstantView.new("div" , "Block name2")])
  end

  def draw
    super()
    wrap_element div("div.block_view") << div("h4" , "Method #{method_name}") << div("h4" , "Block:#{block_name}" )
    return @element
  end

  def blocks
    return [] unless @interpreter.instruction
    codes = @interpreter.block.codes.dup
    slice = codes.index(@interpreter.instruction) #- 1
    codes.shift( slice ) if slice >= 0
    codes.pop while(codes.length > 4)
    codes
  end

  def instruction_changed
    puts "Should have done something here to redraw (blocks)"
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
class BlocksModel #< Volt::ArrayModel

  def instruction_changed old , ins
    self.last._class_name = "inactive" if( self.length > 0)
    self << { :name => ins.to_s , :class_name => "bright" }
    #puts "block #{self.length}"
    self.delete_at(0) if( self.length > 5)
  end

end
