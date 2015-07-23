
class Interpreter

  attr_accessor :instruction
  attr_accessor :registers

  def initialize
    @registers = Hash[(0...12).collect{|i| ["r#{i}" , "undefined"]}]
  end
end
