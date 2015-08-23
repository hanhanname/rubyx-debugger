class ValueView < ElementView

  def initialize  value
    @value = value
  end

  def draw
    @element = div("ul.nav!") << div("li") << div("span",  @value)
  end
end
