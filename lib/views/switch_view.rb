require_relative "classes_view"

class SwitchView < ListView
  def initialize interpreter
    super([ SelectView.new(interpreter) , ClassesView.new(interpreter) ])
  end

  def draw
    super(".classes")
  end
end

class SelectView < ElementView
  include AST::Sexp
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
    promise = Browser::HTTP.get "/codes.json"
    promise.then do |response|
      @codes = response.text.split("----")
      add_selection
    end
  end

  def add_selection
    list = div "ul"
    @codes << @codes.first if @codes.length == 1
    @codes.each do |c|
      code = div("li") << div("a" , c )
      code.on("click"){ select(c) }
      list <<  code
    end
    select(@codes.first)
    @element.at_css(".code_list") <<  list
  end

  def select code
    @interpreter.set_state :stopped
    @element.at_css(".selected").text = code
    promise = Browser::HTTP.get "/#{code}.json"
    promise.then do |response|
      code = nil
      begin
        code = Kernel.eval response.text
      rescue => e
        @element.at_css(".selected").text = "error, see console"
        puts e
      end
      machine = Virtual.machine.boot
      Phisol::Compiler.compile( code  )
      machine.collect
      @interpreter.start machine.init
    end
  end
end
