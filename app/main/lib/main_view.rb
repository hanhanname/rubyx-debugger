require 'opal/pixi'
require 'native'
require "main/lib/registers_view"

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

    @container.add_child RegisterView.new(height - 150)

    animate = Proc.new do
      `requestAnimationFrame(animate)`
       renderer.render @container
    end
    animate.call

  end

  attr_reader :container
end
