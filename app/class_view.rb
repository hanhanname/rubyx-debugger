class ClassView
  include React::Component

  required_param :classes, type: {}

  def render
    div.classes do
      h4 { "Classes" }
      classes.each do |name , clas|
        div.one_class do
           clas.name
        end
      end
    end
  end
end
