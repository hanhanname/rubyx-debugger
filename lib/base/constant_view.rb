require_relative "element_view"

class ConstantView < ElementView

  def initialize class_or_id , text = nil
    @class_or_id = class_or_id
    @text = text
  end

  def draw
    @element = div(@class_or_id , @text)
  end

end
