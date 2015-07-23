
class Debugger

  include React::Component
  required_param :machine , :type => Virtual::Machine
  define_state :interpreter  => Interpreter.new

  def render
    div.container do
      div.row do
        div.col_md_1 do
          ClassView classes: machine.space.classes
        end
        div.col_md_11 do
          div.row do
            div.col_md_4 do
              "Future one"
            end
            div.col_md_4 do
              "Future two"
            end
            div.col_md_4 do
              BlockView block: [ "block 1" , "block 2"]
            end
          end
          RegisterView registers: interpreter.registers
        end
      end
    end

  end
end
