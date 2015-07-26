require "register_view"

class RegistersView

  include React::Component

  required_param :interpreter

  def render
    div.row  do
      interpreter.registers.each do |r , has|
        div.col_md_1 do
          div.row do
            div.col_md_12 do
              " #{has}"
            end
            div.col_md_12 do
              ObjectView  :object_id => has
            end
          end
        end #row
      end
    end
  end

end
