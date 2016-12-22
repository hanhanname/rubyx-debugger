require_relative "classes_view"

class SwitchView < ListView
  def initialize interpreter
    super([ SelectView.new(interpreter) , ClassesView.new(interpreter) ])
  end

  def draw
    super(".classes")
  end
end
# opal eval seems to get the scope wrong and evals in object (not where its called)
include AST::Sexp

class SelectView < ElementView

  def initialize interpreter
    @interpreter = interpreter
    @codes = nil
  end

  def draw
    @element =  div("h4", "Code") << (list = div("ul.nav!"))
    list << (div("li.code_list") << div("a.selected" , "none selected"))
    get_codes unless @codes
    @element << div("br")
    @element << div("br")
  end

  def get_codes
    @codes = ["1", "2"]
    add_selection
  end

  def add_selection
    list = div "ul"
    @codes << @codes.first if @codes.length == 1
    @codes.each do |c|
      code = div("li") << div("a" , c )
      code.on("click"){ select(c) }
      list <<  code
    end
    Promise.new.then{
      select(@codes.first)      
    }
    @element.at_css(".code_list") <<  list
  end

  def select code
    @interpreter.set_state :stopped
    @element.at_css(".selected").text = code
    input = s(:statements, s(:return, s(:operator_value, :+, s(:int, 5), s(:int, 7))))

    machine = Register.machine.boot
    #do_clean_compile
    Typed.compile( input )
    machine.collect

    puts "starting"
    @interpreter.start machine.init
  end
end
