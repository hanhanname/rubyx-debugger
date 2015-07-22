class RegisterView

  include React::Component
  required_param :registers, type: []

  def render
    div :class => :row  do
      registers.each do |r|
        div :class => "col-md-1" do
          r
        end
      end
    end
  end
end
