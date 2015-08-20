class BlocksView < ElementView

  def initialize interpreter
    @interpreter = interpreter
    @interpreter.register_event(:instruction_changed,  self)
  end

  def draw
    DOM do |dom|
      dom.div.block_view do
        dom.div do
          dom.h4  { method_name }
          dom.h4 {"Block:#{block_name}" }
        end
        blocks.each do |b|
          dom.div do
            dom.span do # class="{{b._class_name}}">
              b.name
            end
          end
        end
      end
    end
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
