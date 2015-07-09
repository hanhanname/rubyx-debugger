require 'opal/pixi'
require 'native'
#require_relative "registers"

class Game

  def initialize
    stage = PIXI::Container.new

    height = `window.innerHeight`
    width =  `window.innerWidth`
    puts width
    renderer = PIXI::WebGLRenderer.new( width - 100 , height - 100, {})

    # opal-jquery would clean this up
    body = Native(`window.document.body`)
    # bit of a hack as it assumes index's structure
    html_con = body.firstElementChild
    html_con.insertBefore renderer.view , html_con.lastElementChild

    texture = PIXI::Texture.from_image "/assets/images/bunny.png"
    bunny = PIXI::Sprite.new texture
    bunny.anchor = PIXI::Point.new(0.5, 0.5)
    bunny.position = PIXI::Point.new(300, 150)

    stage.add_child(bunny)

    animate = Proc.new do
      `requestAnimationFrame(animate)`
      bunny.rotation += 0.1
      renderer.render stage
    end
    animate.call
  end
end
