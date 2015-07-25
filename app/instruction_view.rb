

class InstructionView

  include React::Component
  required_param :interpreter
  required_param :instruction

  define_state :active => ""

  before_mount do
    interpreter.register_event(:instruction_changed,  self)
  end

  def instruction_changed old , ins
    active! instruction == ins ? "active" : ""
  end

  def render
    return unless instruction
    div :class => active do
      instruction.to_s
    end
  end
end
