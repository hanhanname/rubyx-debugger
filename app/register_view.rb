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
    div.row  do
      registers.each do |r , has|
        div.col_md_1 do
          div.row do
            div.col_md_12 do
              "#{r} : #{has}"
            end
            if object = has_object(has)
              div.col_md_12 do
                object.class.name.split("::").last.span
              end
              object.get_instance_variables.each do |variable|
                div.col_md_12 do
                  ## deal with String
                  ## even better, make ObjectView
                  object.get_instance_variable(variable).to_s.span
                end
              end
            end #if
          end
        end #row
      end
    end
  end

  def has_object has
    object = Virtual.machine.objects[has]
  end
end
