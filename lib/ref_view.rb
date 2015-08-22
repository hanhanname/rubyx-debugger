class RefView < ElementView

  def initialize name  , value
    @name = name
    @value = value
  end

  attr_accessor :value
  
  def draw
    @element =  div("li") << div("a" ,  "#{@name} : #{marker(@value)}" )
  end

  def marker id
    var = Virtual.machine.objects[id]
    if var.is_a? String
      str "Wo"
    else
      str = var.class.name.split("::").last[0,2]
    end
    str + " : #{id.to_s}"
  end

end
