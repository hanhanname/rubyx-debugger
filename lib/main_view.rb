require 'browser'
require 'native'
require "salama"
require "point"

require_relative "registers_view"
require_relative "object_view"
require_relative "space_view"

class MainView

  def initialize
    @canvas = Browser::Canvas.new

    height = `window.innerHeight`
    width =  `window.innerWidth`

    body = Native(`window.document.body`)
    # bit of a hack as it assumes index's structure
    html_con = body.firstElementChild
    html_con.insertBefore renderer.view , html_con.lastElementChild

    registers = RegisterView.new(height - 150)
    @canvas.add_child registers

    ParseTask.parse(1).then do |result|
      is = Ast::Expression.from_basic(result)
      Virtual::Compiler.compile( is , Virtual.machine.space.get_main )
      Virtual.machine.run_before Virtual::Machine::FIRST_PASS
    end.fail do |error|
      raise "Error: #{error}"
    end
    space = SpaceView.new
    @container.add_child space

    animate = Proc.new do
      `requestAnimationFrame(animate)`
      registers.draw_me
      space.draw_me
      renderer.render @container
    end
    animate.call

  end

  attr_reader :container
end
