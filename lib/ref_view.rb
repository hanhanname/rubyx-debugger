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
    return if is_string?
    @element.on("hover"){ hover } if is_object?(@value)
  end

  def is_object?(  )
   Virtual.machine.objects[@value] != nil
  end

  def is_string?()
    Virtual.machine.objects[@value].is_a? String
  end

  def is_nil?()
    Virtual.machine.objects[@value].nil?
  end

  def hover
    puts "hovering #{@name}"
    append_view ObjectView.new(@value)
    @element.off("hover")
  end

  def marker id
    if is_string?
      str = @value
    elsif is_nil?
      str = "nil"
    else
      var = Virtual.machine.objects[id]
      str = var.class.name.split("::").last[0,2]
      str + " : #{id.to_s}"
    end
  end

end
