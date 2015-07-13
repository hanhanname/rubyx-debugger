
class SpaceView < PIXI::Graphics
  include Sof::Util

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
      view._object = o
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

  def fill_attributes
    @view_objects.each do |i , view|
      object = view._object
      case object.class.name
      when "Array" , "Parfait::List"
        fill_array view
      when "Hash" , "Parfait::Dictionary"
        fill_hash view
      else
        # and recursively add attributes
        attributes = attributes_for(object)
        attributes.each do |a|
          val = get_value( object , a)
          if( @view_objects[vol.object_id])
            #ref
          end
          view.set(a , val )
        end
        superclasses = [object.class.superclass.name]
        if superclasses.include?( "Array") or superclasses.include?( "Parfait::List")
          fill_array view
        end
        if superclasses.include?( "Hash") or superclasses.include?( "Parfait::Dictionary")
          fill_hash view
        end
        view._object = nil
      end
    end
  end

  # and hash keys/values
  def fill_hash hash
    return
    hash.each do |a,b|
      next_level << a
      next_level << b
    end
  end
  # and array values
  def fill_array array
    return
    array.each do |a|
      next_level << a
    end
  end


end
