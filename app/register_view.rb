class RegisterView

  include React::Component
  required_param :interpreter
  define_state :registers

  before_mount do
    interpreter.register_event(:register_changed,  self)
    registers! interpreter.registers
  end

  def register_changed reg , old , bl
    registers! interpreter.registers
  end

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
