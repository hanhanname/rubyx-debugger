
require "math"

PIXI::Point.class_eval do
  alias_native :y=

  def add point
    self.x += point.x
    self.x = 0    if self.x  < 0
    self.x = 1100  if self.x  > 1100
    self.y += point.y
    self.y = 0    if self.y  < 0
    self.y = 550    if self.y  > 550
  end

  def scale_by num
    min = 0.001
    num = min if num <= min
    self.x = self.x / num
    self.y = self.y / num
  end
end

class SpaceView < PIXI::Graphics
  include Sof::Util

  def initialize
    super()
    space = Virtual.machine.space
    # just a way to get the space into a list. objects is an id => occurence mapping.
    # occurence.object is the object
    objects = Sof::Members.new(space).objects
    @objects = objects
    puts "Objects #{objects.length}"
    # create a mapping from id to volt models
    @view_objects = {}

    @objects.each do |i , o|
      next unless o.object
      view = ObjectView.new o.object
      @view_objects[i] = view
      add_child view.text
    end
    fill_attributes
  end

  # should almost be called draw by now
  def draw_me
    update_positions
    self.clear
    @view_objects.each do |i , view|
      self.lineStyle(4, 0xffd900, 2)
      puts "v" if view.nil?
      view.attributes.each do |n , v |
        next if n == :id
        next unless v.is_a? ObjectView
        next unless v.is_parfait
        puts "v2" if view.nil?
        puts "0" if v.nil?
        self.moveTo( view.position.x , view.position.y )
        self.lineTo( v.position.x , v.position.y )
      end
    end
  end

  def force from , to
    dir_x = from.x - to.x - 100
    dir_x2 = dir_x * dir_x
    dir_y = from.y - to.y - 100
    dir_y2 = dir_y * dir_y
    if( dir_x2 < 0.1 and dir_y2 < 0.1 )
      puts "Were close"
      dir_x = rand(10) - 5
      dir_y = rand(10) - 5
    end
    f = dir_x * dir_x + dir_y * dir_y
    f = 0.01 if f < 0.01
    f = f / 100
    #puts "force #{f}"
    PIXI::Point.new( dir_x / f  , dir_y / f)
  end

  def update_positions
    @view_objects.each do |i , view|
      view.attributes.each do |n , v |
        next if n == :id
        next unless v.is_a? ObjectView
        next unless v.is_parfait
        puts "v2" if view.nil?
        puts "0" if v.nil?
        view.position.add force( view.position , v.position )
      end
      offset = 0.0
      view.position.add force( view.position , PIXI::Point.new(view.position.x , -offset) )
      view.position.add force( view.position , PIXI::Point.new(-offset , view.position.y) )
      view.position.add force( view.position , PIXI::Point.new(view.position.x , 550 + offset) )
      view.position.add force( view.position , PIXI::Point.new(1000 + offset , view.position.y) )
    end
  end

  def fill_attributes
    @view_objects.each do |i , view|
      ob = view.object
      next if is_value?(ob)
      case ob.class.name
      when "Array" , "Parfait::List"
        fill_array view
      when "Hash" , "Parfait::Dictionary"
        fill_hash view
      else
        next if ob.class.name.include?("::") and !ob.class.name.include?("Parfait")
        next if ob.class.name == "Proc"
        next if ob.class.name == "String"
        next if ob.class.name == "Numeric"
        next if ob.class.name == "Class"
        #puts "object #{ob.class.name}"

        attributes = attributes_for(ob)
        attributes.each do |a|
          next if a == "html_safe"
          next if a == "constructor"
          next if a == "toString"
          next if a == "position"
          val = get_value( ob , a)
          if( @view_objects[val.object_id])
            val = @view_objects[val.object_id]
          end
          #puts "set #{a}"
          view.set(a , val )
        end
        superclasses = [ob.class.superclass.name]
        if superclasses.include?( "Array") or superclasses.include?( "Parfait::List")
          fill_array view
        end
        if superclasses.include?( "Hash") or superclasses.include?( "Parfait::Dictionary")
          fill_hash view
        end
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
