
class ObjectView

  attr_accessor :text , :object , :attributes

  def initialize o
    super()
    puts "NO O " unless o
    self.object = o
    self.text = short
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

end
