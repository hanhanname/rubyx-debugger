
PIXI::Point.class_eval do
  alias_native :y=

  def add point
    self.x += point.x
    self.y += point.y
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
    prev = nil
    @view_objects.each do |i , view|
      if prev
        self.lineStyle(4, 0xffd900, 2)
        puts "p" if prev.nil?
        puts "v" if view.nil?
        self.moveTo( prev.position.x , prev.position.y )
        self.lineTo( view.position.x , view.position.y )
      end
      prev = view
    end
  end

  def force from , to
    puts "force"
    dir_x = from.x - to.x
    dir_x2 = dir_x * dir_x
    dir_y = from.y - to.y
    dir_y2 = dir_y * dir_y
    if( dir_x2 < 0.1 and dir_y2 < 0.1 )
      puts "Were close"
      dir_x = rand(10)
      dir_y = rand(10)
    end
    f = dir_x * dir_x + dir_y * dir_y
    f = 0.1 if f < 0.1
    PIXI::Point.new( dir_x / f  , dir_y / f)
  end

  def update_positions
    @view_objects.each do |i , view|
      view.each do |n , v |
        next if n == :id
        next unless o = @view_objects[v]
        puts "v2" if view.nil?
        puts "0" if o.nil?
        view.position.add force( view.position , o.position )
      end
    end
  end

  def fill_attributes
    @view_objects.each do |i , view|
      ob = view._object
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
            #ref
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
