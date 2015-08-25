require "base/constant_view"
require "base/list_view"

class InstructionView < ListView

  def initialize interpreter
    @interpreter = interpreter
    super([ConstantView.new( "span.bright" , "starting" )])
    @interpreter.register_event(:instruction_changed,  self)
  end

  def instruction_changed
    @element.at_css(".bright").remove_class("bright")
    instruction = append_view( ConstantView.new( "span.bright" , instruction_text ) )
    wrap_node_with instruction , div
    remove_first if( @elements.length > 6)
  end

  def draw
    super()
    wrap_node_with @elements.first , div
    wrap_element div(".source_view") << div("h4" ,"Virtual Machine Instruction")
    @element
  end

  def instruction_text
    return "" unless @interpreter.instruction
    @interpreter.instruction.to_s
  end
end
