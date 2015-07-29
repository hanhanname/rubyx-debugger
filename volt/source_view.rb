class SourceView

  include React::Component

  required_param :interpreter

  define_state :sources => []

  before_mount do
    interpreter.register_event(:instruction_changed,  self)
    instruction_changed nil , interpreter.instruction
  end

  def instruction_changed old , ins
    text = ins ? source_text(ins.source) : "exit"
    return if sources.last == text
    sources << text
    sources.shift if sources.length > 5
    sources! sources
  end

  def render
    div.source_view do
      h4 {"Virtual Machine Instruction"}
      sources.each do |s|
        s.br
      end
    end
  end

  def source_text source
    if source.is_a? Virtual::Instruction
      return source.class.name
    else
      return "Method: #{source.name}"
    end
  end
end
