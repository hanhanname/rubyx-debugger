require "base/constant_view"
require "base/list_view"

class RiscView < ListView

  def initialize interpreter
    @interpreter = interpreter
    super([start_view])
    @interpreter.register_event(:instruction_changed,  self)
    @interpreter.register_event(:state_changed,  self)
  end

  def start_view
    ConstantView.new( "span.risc_bright" , "starting" )
  end

  def instruction_changed
    @element.at_css(".risc_bright").remove_class("risc_bright")
    instruction = append_view( ConstantView.new( "span.risc_bright" , instruction_text ) )
    wrap_node_with instruction , div
    remove_first if( @elements.length > 6)
  end

  def draw
    super()
    wrap_node_with @elements.first , div
    wrap_element div(".risc_view") << div("h4" ,"Register Machine Instruction")
    @element
  end

  def state_changed old , new_s
    return unless new_s == :running
    clear_view
    append_view start_view
  end

  def instruction_text
    return "" unless @interpreter.instruction
    @interpreter.instruction.to_s.split("(").first
  end

end
