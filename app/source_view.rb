class SourceView

  include React::Component

  required_param :source

  define_state :sources => []

  before_update do
    text = source_text(source)
    return if sources.last == text
    sources << text
    sources.shift if sources.length > 5
  end
  def render
    div.row  do
      "Virtual Machine Instruction".br
      sources.each do |s|
        s.br
      end
    end
  end

  def source_text
    if source.is_a? Virtual::Instruction
      return source.class.name
    else
      return "Method: #{source.name}"
    end
  end
end
