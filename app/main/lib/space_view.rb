
class SpaceView < PIXI::Graphics

  def initialize
    super()
    space = Virtual.machine.space
    # just a way to get the space into a list. objects is an id => occurence mapping.
    # occurence.object is the object
    objects = Sof::Members.new(space).objects
    @objects = objects
    # create a mapping from id to volt models
    @view_objects = {}

    @objects.each do |i , o|
      view = Volt::Model.new
#      view._object_id = i
      @view_objects[i] = view
      at = PIXI::Point.new 100 , 100
      name = PIXI::Text.new i.to_s
      view._name = name
      add_child name
    end

  end

  # should almost be called draw by now
  def update
    update_positions
    self.clear
    prev = nil
    @view_objects.each do |i , view|
      if prev
        self.lineStyle(4, 0xffd900, 2)
        self.moveTo( prev._name.position.x , prev._name.position.y )
        self.lineTo( view._name.position.x , view._name.position.y )
      end
      prev = view
    end
  end

  def update_positions
    @view_objects.each do |i , view|
      view._name.position.x += 1
    end
  end
end
