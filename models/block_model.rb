
# represent a block and hold the actual instance (as transient)

class BlockModel < Volt::Model
  field :name
  attr_accessor :block

  def initialize(b)
    super()
    @block = b
    self.name = b.nil? ? 'undefined' : b.name
  end
end
