
class StatusView

  include React::Component
  required_param :interpreter

  define_state :state => "starting"
  define_state :stdout

  before_mount do
    interpreter.register_event(:instruction_changed,  self)
  end

  def update_state
    state! interpreter.state
    stdout! interpreter.stdout
  end

  def instruction_changed old , nex
    update_state
  end

  def render
    div.status_view do
      div do
        button.btn.btn_default { "next" }.on(:click) { interpreter.tick }
        " ".br
      end
      div do
        h4 {"Status:"}
        state.to_s.br
      end
      div do
        h4 {"Stdout:"}
      end
      div do
        interpreter.stdout.br
      end
    end
  end
end
