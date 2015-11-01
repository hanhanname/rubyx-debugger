class SourceView < ElementView

  def initialize interpreter
    @interpreter = interpreter
    @interpreter.register_event(:instruction_changed,  self)
  end

  def draw
    @text = div
    @ticker = div
    @element = div(".source_view") << div("h4.source" , "Class.Method") << @ticker << @text
    @element
  end

  def instruction_changed
    i = @interpreter.instruction
    return "" unless i
    if( i.is_a?(Register::Label) and i.name.include?("."))
      update_method
    end
    case i.source
    when AST::Node
      update_code
      @ticker.text = ""
    when String
      @ticker.text = i.source
    else
      raise i.source.class.name
    end
  end
  def update_method
    @element.at_css(".source").text = @interpreter.instruction.name
    cl_name , method_name = *@interpreter.instruction.name.split(".")
    clazz = Register.machine.space.get_class_by_name cl_name
    method = clazz.get_instance_method( method_name)
    puts "found method #{method.source.class}"
    html =     ToCode.new.process( method.source )
    puts html
    @text.inner_html = html
  end

  def update_code
    @text.inner_html = ToCode.new.process( @interpreter.instruction.source)
  end
end
class ToCode <   AST::Processor

  def handler_missing s
    puts "Missing: " + s.type
    s.to_sexp
  end
  def div statement , html
    "<div class='statement #{statement.object_id}'>" + html + "</div>"
  end
  def span statement , html
    "<span class='#{statement.object_id}'>" + html + "</span>"
  end
  def on_function  statement
    return_type , name , parameters, kids , receiver = *statement
    str = return_type + " "
    str += receiver + "." if receiver
    str += name.to_a.first + "("
    str += process(parameters) + ")<br>"
    str += process(kids) + "end<br>"
    div(statement,str)
  end
  def on_parameters statement
    process_all(statement.children).join(",")
  end
  def on_parameter p
    type , name = *p
    span(type,type) + " " + span(name,name)
  end
  def on_string s
    span(s, "'" + s.first + "'")
  end
  def on_field_def statement
    type , name , value = *statement
    str = span(type, type) + " " + span(name,name)
    str += " = #{process(value)}" if value
    div(s,str)
  end
  def on_return statement
    str = "return "  + process(statement.first )
    div(statement,str)
  end
  def on_false_statements s
    on_statements s
  end
  def on_true_statements s
    on_statements s
  end
  def on_statements s
    str = ""
    s.children.each do |c|
      str += process(c).to_s
    end
    div(s,str)
  end
  def on_if_statement statement
    branch_type , condition , if_true , if_false = *statement
    condition = condition.first
    ret = "if_#{branch_type}(" + process(condition) + ")<br>" + process(if_true)
    ret += "else" + "<br>" +  process(if_false)  if if_false
    ret += "end"
    div(statement,ret)
  end
  def on_assignment statement
    name , value = *statement
    name = name.to_a.first
    v = process(value)
    str = name + " = " + v
    div(statement,str)
  end
  def on_call c
    name , arguments , receiver = *c
    ret = process(name)
    ret += process(receiver.first) + "." + ret if receiver
    ret += "("
    ret += process(arguments).join(",")
    ret += ")"
    span(c,ret)
  end
  def on_operator_value statement
    operator , left_e , right_e = *statement
    left_reg = process(left_e)
    right_reg = process(right_e)
    span(statement , left_reg + " " + operator + " " + right_reg )
  end
  def on_arguments args
    args.children.collect{|c| process(c)}
  end
  def on_name name
    span(name,name.first)
  end
  def on_int i
    span(i , i.first.to_s)
  end
end
