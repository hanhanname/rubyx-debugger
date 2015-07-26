

class InstructionView

  include React::Component
  required_param :interpreter
  required_param :instruction

  define_state :active => ""

  before_mount do
    check_active interpreter.instruction
  end

  def check_active i
    active! instruction == i ? "active" : ""

  end
  def instruction_changed old , ins
    check_active ins
  end

  def render
    return unless instruction
    div :class => active do
      instruction.to_s
    end
  end
end
