class InstructionView

  include React::Component
  required_param :interpreter
  required_param :instruction

  define_state :active => ""

  before_mount do
    check_active interpreter.instruction
  end

  def check_active i
    active! instruction == i ? "bright" : ""

  end
  def instruction_changed old , ins
    check_active ins
  end

  def render
    div :class => active do
      instruction.to_s if instruction
    end
  end
end


<div class="source-view">
  <h4> Virtual Machine Instruction </h4>
  {{page._sources.each do |source| }}
    <div>
      <span class="{{source._class_name}}">
        {{source._name}}
      </span>
    </div>
  {{end}}
</div>
