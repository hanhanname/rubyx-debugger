require_relative "element_view"

# A very simple ElementView with constant text and class. It uses the ElementView.div function
# to generate the html, see there for details
#
class ConstantView < ElementView

  # store the class and text
  def initialize class_or_id , text = nil
    @class_or_id = class_or_id
    @text = text
  end

  # use ElementView.div to create html from the class and text 
  def draw
    @element = div(@class_or_id , @text)
  end

end
