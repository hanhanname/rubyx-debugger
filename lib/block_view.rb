class BlockView < ElementView

  def initialize block
    @block = block
  end
  attr_reader :block
  
  def draw
    @element = div("div") << div("span.bright" , @block.name )
  end

end
