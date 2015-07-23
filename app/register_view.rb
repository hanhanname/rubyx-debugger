class RegisterView

  include React::Component
  required_param :interpreter

  def render
    div :class => :row  do
      interpreter.registers.each do |r , has|
        div :class => "col-md-1" do
          "#{r} : #{has}"
        end
      end
    end
  end
end
