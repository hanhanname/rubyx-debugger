
class ObjectView

  attr_accessor :text , :object , :attributes

  def initialize o
    super()
    self.text =  PIXI::Text.new("no")
    puts "NO O " unless o
    self.object = o
    self.text.text = o.object_id.to_s
    @attributes = {}
  end

  def set name , val
    @attributes[name] = val
  end
  def get(name)
    @attributes[name]
  end
  def position
    #raise "NONAME" unless self.text
    self.text.position
  end

  def distance to
    self.position - to.position
  end
end
