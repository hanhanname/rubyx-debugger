require "base/constant_view"
require "base/list_view"

class MomView < ListView

  def initialize interpreter
    @interpreter = interpreter
    @current = nil
    super([start_view])
    @interpreter.register_event(:instruction_changed,  self)
    @interpreter.register_event(:state_changed,  self)
  end

  def start_view
    ConstantView.new( "span.mom_bright" , "starting" )
  end

  def instruction_changed
    i = @interpreter.instruction
    return unless i && i.source.is_a?(Mom::Instruction)
    return if i.source == @current
    @current = i.source
    @element.at_css(".mom_bright").remove_class("mom_bright")
    instruction = append_view( ConstantView.new( "span.mom_bright" , @current.to_s ) )
    wrap_node_with( instruction , div )
    remove_first if( @elements.length > 6)
  end

  def draw
    super()
    wrap_node_with @elements.first , div
    wrap_element div(".mom_view") << div("h4" ,"Mom::Instruction")
    @element
  end

  def state_changed(old , new_s)
    return unless new_s == :running
    clear_view
    @current = nil
    append_view start_view
  end

end
