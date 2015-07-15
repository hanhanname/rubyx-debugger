
class SpaceView
  include Sof::Util

  def initialize max
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
      ob = o.object
      next unless ob
      next if basic?(ob)
      next if ob.class.name.include? "Binary"
      next if ob.class.name.include? "Array"
      puts "object #{ob.class.name}"

      view = ObjectView.new ob
      @view_objects[i] = view
      add_child view.text
    end
    fill_attributes
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
#        next if basic?(ob)

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

  def basic? ob
    return true if ob.class.name.include?("::") and !ob.class.name.include?("Parfait")
    return true if ob.class.name == "Proc"
    return true if ob.class.name == "String"
    return true if ob.class.name == "Numeric"
    return true if ob.class.name == "Class"
    false
  end
  # and hash keys/values
  def fill_hash view_hash
    view_hash.object.each do |k , val|
      if( @view_objects[val.object_id])
        val = @view_objects[val.object_id]
      end
      view_hash.set(k , val )
    end
  end
  # and array values
  def fill_array view_array
    index = 0
    view_array.object.each do |val|
      if( @view_objects[val.object_id])
        val = @view_objects[val.object_id]
      end
      view_array.set("#{index}" , val )
      index += 1
    end
    #puts "set #{a}"
  end

end
