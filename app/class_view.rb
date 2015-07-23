class ClassView
  include React::Component

  required_param :classes, type: {}

  def render
    div.row do
      classes.each do |name , clas|
        div.row do
           clas.name.span
        end
      end
    end
  end
end
