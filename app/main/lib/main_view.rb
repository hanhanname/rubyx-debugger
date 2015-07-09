require 'opal/pixi'
require 'native'
require "main/lib/registers_view"
require "main/lib/space_view"
require "salama"

class MainView

  def initialize
    @container = PIXI::Container.new

    height = `window.innerHeight`
    width =  `window.innerWidth`
    renderer = PIXI::WebGLRenderer.new( width - 100 , height - 100, {"backgroundColor" => 0xFFFFFF})
    body = Native(`window.document.body`)
    # bit of a hack as it assumes index's structure
    html_con = body.firstElementChild
    html_con.insertBefore renderer.view , html_con.lastElementChild

    registers = RegisterView.new(height - 150)
    @container.add_child registers
    space = SpaceView.new
    @container.add_child space

    animate = Proc.new do
      `requestAnimationFrame(animate)`
      registers.update
      space.update
      renderer.render @container
    end
    animate.call

    string_input    = '"Hello again\n".putstring()'

    machine = ::Virtual::Machine.boot
    expressions = machine.compile_main string_input
    if( expressions.first.is_a? Parfait::Method )
      # stops the whole objectspace beeing tested
      # with the class comes superclass and all methods
      expressions.first.instance_variable_set :@for_class , nil
      expressions.first.secret_layout_hammer
      expressions.first.code.secret_layout_hammer
    end
    if( expressions.first.is_a? Virtual::Self )
      # stops the whole objectspace beeing tested
      # with the class comes superclass and all methods
      expressions.first.type.instance_variable_set :@of_class , nil
    end
    is = Sof.write(expressions)
    #puts is
    is.gsub!("\n" , "*^*")

  end

  attr_reader :container
end
