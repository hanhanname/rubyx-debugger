class RegisterView

  include React::Component
  required_param :registers, type: {}

  def render
    div :class => :row  do
      registers.each do |r , has|
        div :class => "col-md-1" do
          "#{r} : #{has}"
        end
      end
    end
  end
end
