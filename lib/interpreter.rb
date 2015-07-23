
class Interpreter

  attr_accessor :instruction
  attr_accessor :registers

  def initialize
    @registers = (0...12).collect{|i| "r#{i}"}
  end
end
