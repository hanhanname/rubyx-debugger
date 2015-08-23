class RefView < ListView

  def initialize name  , value , z = nil
    @name = name
    @value = value
    @z = z
    super []
  end

  attr_reader :value

  def value= val
    @value = val
    add_hover
  end

  def draw
    @element =  div("li") << div("a" ,  "#{@name} : #{marker(@value)}" )
    add_hover
    @element.style["z-index"] = @z if @z
    @element
  end

  def add_hover
    @element.on("hover"){ hover } if is_object?(@value)
  end

  def is_object?( id )
   Virtual.machine.objects[id] != nil
  end

  def hover
    puts "hovering #{@name}"
    append ObjectView.new(@value)
    @element.off("hover")
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
