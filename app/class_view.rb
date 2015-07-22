class ClassView
  include React::Component

  required_param :classes, type: Hash

  def render
    div :class => "row" do
      classes.each do |name , clas|
        div :class => "row" do
           clas.name.span
        end
      end
    end
  end
end
