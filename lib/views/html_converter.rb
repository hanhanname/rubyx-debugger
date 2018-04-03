class HtmlConverter < AST::Processor

  alias  :old_process :process
  def process s
    return "" unless s
    #puts s.type
    old_process(s)
  end
  def handler_missing s
    puts "Missing: " + s.type
    "Missing #{s.type}"
  end
  def div statement , html
    "<div class='statement' id='i#{statement.object_id.to_s(16)}'>" + html + "</div>"
  end
  def span statement , html
    "<span class='expression' id='i#{statement.object_id.to_s(16)}'>" + html + "</span>"
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
  def on_receiver expression
    span expression , process(expression.first)
  end
  def on_field expression
    span expression , process(expression.first)
  end
  def on_field_access statement
    receiver_ast , field_ast = *statement
    receiver = process(receiver_ast)
    field = process(field_ast)
    span( statement , receiver + "." + field)
  end
  def on_field_def statement
    type , name , value = *statement
    str = span(type, type) + " " + process(name)
    str += " = #{process(value)}" if value
    div(statement,str)
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
  def on_while_statement statement
    branch_type , condition , statements = *statement
    condition = condition.first
    ret = "while_#{branch_type}(" + process(condition) + ")<br>"
    ret += process(statements)
    ret += "end"
    div(statement,ret)
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
    name = process(name)
    v = process(value)
    str = name + " = " + v
    div(statement,str)
  end
  def on_call c
    name , arguments , receiver = *c
    ret = process(name)
    ret = process(receiver.first) + "." + ret if receiver
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
