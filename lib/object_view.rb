
class ObjectView

  attr_accessor :text , :object , :attributes

  def initialize o
    super()
    self.text =  Text.new("no")
    self.text.position = Point.new( rand(1000) , rand(550))
    puts "NO O " unless o
    self.object = o
    self.text.text = short
    @attributes = {}
  end

  def short
    object.class.name.split("::").last[0 .. 3]
  end

  def is_parfait
    object.class.name.split("::").first == "Parfait"
  end
  def set name , val
    @attributes[name] = val
    self.text.text = short + @attributes.length.to_s
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
