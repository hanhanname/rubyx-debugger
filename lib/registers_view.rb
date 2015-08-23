require_relative "object_view"
require_relative "value_view"

class RegistersView < ListView

  def initialize interpreter
    @interpreter = interpreter
    @interpreter.register_event(:register_changed,  self)
    kids = []
    @interpreter.registers.each do |reg , val|
      kids << ValueView.new( val )
    end
    super(kids)
  end

  def draw
    super( "div.registers_view" )
    @element.children.each_with_index do |reg, index|
      elem = div("div.register_view")
      wrap_node_with reg , elem
    end
    @element
  end

  def register_changed reg , old , value
    reg = reg.symbol unless reg.is_a? Symbol
    index = reg.to_s[1 .. -1 ].to_i
    if( is_object? value )
      swap =  ObjectView.new( value , @interpreter , 16 - index )
    else
      swap = ValueView.new value
    end
    replace_at index , swap
#    @elements[index].style["z-index"] = -index
  end

  def is_object?( id )
    Virtual.machine.objects[id] != nil
  end

end
