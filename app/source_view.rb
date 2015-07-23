class SourceView

  include React::Component

  required_param :source, type: Virtual::Instruction

  def render
    div.row  do
      "Virtual Machine Instruction".span
      source
    end
  end

end
