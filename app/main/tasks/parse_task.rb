require "salama-reader"

class ParseTask < Volt::Task
  def parse(num)
    string_input    = '"Hello again".putstring()'
    parser = Parser::Salama.new
    out = parser.parse(string_input)
    parts = Parser::Transform.new.apply(out)
    parts.to_basic
  end
end
