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

    ParseTask.parse(1).then do |result|
      is = Ast::Expression.from_basic(result)
      Virtual::Compiler.compile( is , Virtual.machine.space.get_main )
      puts Virtual.machine.space
    end.fail do |error|
      puts "Error: #{error}"
    end
    space = SpaceView.new  Sof::Members.new(Virtual.machine.space).objects
    @container.add_child space

    animate = Proc.new do
      `requestAnimationFrame(animate)`
      registers.update
      space.update
      renderer.render @container
    end
    animate.call

  end

  attr_reader :container
end
