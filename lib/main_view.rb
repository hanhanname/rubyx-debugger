
require 'browser'
require 'browser/canvas'
require 'browser/http'
require 'native'
require "salama"
require "point"

require_relative "registers_view"
require_relative "object_view"
require_relative "space_view"

class MainView

  def initialize
    @canvas = Browser::Canvas.new
    @canvas.element.width = 1000
    @canvas.element.height = 500
    Browser::HTTP.get "/tasks.json" do
      on :success do |res|
        is = Ast::Expression.from_basic(res.json)
        Virtual::Compiler.compile( is , Virtual.machine.space.get_main )
        Virtual.machine.run_before Virtual::Machine::FIRST_PASS
      end
    end
    @canvas.append_to($document.body)
  end
  def no

    height = `window.innerHeight`
    width =  `window.innerWidth`

    body = Native(`window.document.body`)
    # bit of a hack as it assumes index's structure
    html_con = body.firstElementChild
    html_con.insertBefore renderer.view , html_con.lastElementChild

    registers = RegisterView.new(height - 150)
    @canvas.add_child registers

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
