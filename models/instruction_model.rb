
# represent an instruction and hold the actual instance (as transient)

class InstructionModel < Volt::Model
  field :name
  attr_accessor :instruction

  def initialize(i)
    super()
    @instruction = i
    self.name = i.class.name
  end
end
