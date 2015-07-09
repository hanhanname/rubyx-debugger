
class SpaceView < PIXI::Graphics

  def initialize objects
    super()
    @objects = objects
    @pos1 = PIXI::Point.new 100 , 100
    @pos2 = PIXI::Point.new 200 , 200
    @text1 = PIXI::Text.new "ONE"
    @text2 = PIXI::Text.new "TWO"
    @text1.position = @pos1
    @text2.position = @pos2

    add_child @text1
    add_child @text2

  end

  def update
    self.clear
    self.lineStyle(4, 0xffd900, 2)
    self.moveTo(@pos1.x , @pos1.y )
    self.lineTo( @pos2.x , @pos2.y)
    @pos1.x += 1
  end
end
