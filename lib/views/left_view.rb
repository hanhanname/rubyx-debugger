require_relative "classes_view"

# the whole of the left, ie selection, space and classes
class LeftView < ListView
  def initialize( interpreter )
    @interpreter = interpreter
    super([ SelectView.new(interpreter) ,
      ObjectView.new( Parfait.object_space , @interpreter , 26),
      ClassesView.new(interpreter) ])
    interpreter.register_event(:state_changed,  self)
  end

  # need to re-init when we go to running, as the objects (and the actual space) change
  # we replace space and class view with new instances
  def state_changed( old , new_s )
    return unless new_s == :running
    space = ObjectView.new( Parfait.object_space , @interpreter , 26)
    replace_at( 1 , space )
    replace_at( 2 , ClassesView.new(@interpreter) )
  end

  def draw
    super(".classes")
  end
end


# view for the little code select, implemented as a normal expandable menu
#
# on click calls select method
#
# derive from element, meaning we draw
# # TODO: make into listview, so code can be the next level expansion
class SelectView < ElementView

  def initialize( interpreter )
    super
    @interpreter = interpreter
    @codes = nil
  end

  def draw
    @element =  div("h4.select", "Code") << (list = div("ul.nav!"))
    list << (div("li.code_list") << div("a.selected" , "none selected"))
    selection_codes unless @codes
    @element << div("br")
    @element << div("br")
  end

  def selection_codes
    @codes = get_codes.keys
    list = div "ul"
    @codes.each do |c|
      code = div("li") << div("a" , c )
      code.style["z-index"] = 10
      code.on("click"){ select(c) }
      list << code
    end
    @element.at_css(".code_list") <<  list
  end

  # select method set up as click handler for the codes
  # restart the interpreter after compiling
  def select( code )
    puts "selecting #{code}"
    @interpreter.set_state :stopped
    @element.at_css(".selected").text = code
    ruby = as_main(get_codes[code])
    linker = RubyX::RubyXCompiler.new.ruby_to_binary(ruby, :interpreter)
    @interpreter.start_program(linker)
  end

  def as_main(statements)
    "class Space ;def yielder; return yield ; end;def main(arg) ; #{statements}; end; end"
  end
  def get_codes
    { while_with_calls: 'a = 2; while( 0 < a); a = a - 1;end;return a',
      set_internal_byte: "return 'Hello'.set_internal_byte(1,75)" ,
      basic_if: 'if( 10 ); return "then";else;return "else";end' ,
      plus: 'return 5 + 7' ,
      yield: "a = yielder {return 15} ; return a" ,
      return: 'return 5' ,
      hello_world: "h = 'Hello World'.putstring;return h",
      dynamic_call: "a = 150 ; return a.div10",
      }
  end

end
