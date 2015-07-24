class SourceView

  include React::Component

  required_param :source, type: Virtual::Instruction

  def render
    div.row  do
      "Virtual Machine Instruction".br
      source.class.name
    end
  end

end
