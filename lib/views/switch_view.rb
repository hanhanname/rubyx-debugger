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
    selection_codes unless @codes
    @element << div("br")
    @element << div("br")
  end

  def selection_codes
    @codes = get_codes.keys
    list = div "ul"
    @codes << @codes.first if @codes.length == 1  #otherwise unselectable
    @codes.each do |c|
      code = div("li") << div("a" , c )
      code.on("click"){ select(c) }
      list <<  code
    end
    @element.at_css(".code_list") <<  list
  end

  def select code
    puts "selecting #{code}"
    @interpreter.set_state :stopped
    @element.at_css(".selected").text = code
    main , clean = get_codes[code]

    machine = Register.machine.boot
    clean_compile(*clean) if clean
    Typed.compile( main )
    machine.collect

    puts "starting"
    @interpreter.start machine.init
  end

  def get_codes
    {"set_internal_byte" => [s(:statements, s(:call,
                  s(:name, :set_internal_byte),
                  s(:arguments, s(:int, 1), s(:int, 104)),
                    s(:receiver, s(:string, "Hello"))))  , nil ] ,
      "called_if" => [s(:statements, s(:call, s(:name, :itest), s(:arguments, s(:int, 20)))) ,
                      [:Space , :itest , {:n => :Integer} ,
          s(:statements, s(:if_statement, :zero, s(:condition, s(:operator_value, :-, s(:name, :n), s(:int, 12))),
                  s(:true_statements, s(:call, s(:name, :putstring), s(:arguments), s(:receiver, s(:string, "then")))),
                  s(:false_statements, s(:call, s(:name, :putstring), s(:arguments), s(:receiver, s(:string, "else"))))))]],
      "hello world" => [ s(:statements, s(:return, s(:call, s(:name, :putstring), s(:arguments),
                          s(:receiver, s(:string, "Hello again\\n"))))),
                          nil],
      }
  end
  def clean_compile(clazz_name , method_name , args , statements)
    compiler = Typed::MethodCompiler.new.create_method(clazz_name,method_name,args ).init_method
    compiler.process( Typed.ast_to_code( statements ) )
  end

end
