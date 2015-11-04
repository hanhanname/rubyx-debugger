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
    @element =  div("li") << div("a" ,  ref_text )
    add_hover
    @element.style["z-index"] = @z if @z
    @element
  end

  def ref_text
    "#{@name} : #{marker()}"
  end

  def add_hover
    return if is_string?
    @element.on("hover"){ hover } if is_object?(@value)
  end

  def is_object?(  )
    return false if @value.is_a?(Fixnum)
    return false unless @value
    ! is_label?
  end

  def is_string?()
    @value.is_a? String
  end

  def is_label?
    @value.is_a?(Register::Label)
  end

  def is_nil?()
    @value.nil?
  end

  def hover
    #puts "hovering #{@name}"
    append_view ObjectView.new(@value)
    @element.off("hover")
  end

  def marker
    if is_string?
      str = @value
    elsif is_object?
      var = @value
      str = var.class.name.split("::").last[0,2]
      str + " : #{@value.object_id}"
    elsif is_label?
      str = "Label"
    else
      str = @value.to_s
    end
  end

end
