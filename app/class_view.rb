class ClassView
  include React::Component

  required_param :classes, type: Hash

  def render
    div class: "row" do
      classes.each do |k , clas|
        div :class => "col-md-1" do
           k.span
           clas.span
        end
      end
    end
  end
end
