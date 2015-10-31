require_relative "ref_view"

class ClassesView < ListView

  def initialize interpreter
    @interpreter = interpreter
    @interpreter.register_event(:state_changed,  self)
    super( class_views )
  end

  def class_views
    classes = []
    Register.machine.space.classes.each do |name , claz|
      classes << claz
    end
    classes.sort! {|a,b| a.name <=> b.name }
    classes.collect{|c| ClassView.new(c)}
  end

  def state_changed old , new_s
    return unless new_s == :running
    class_views.each_with_index do |v, i|
      replace_at i , v
    end
  end

  def draw
    super()
    wrap_element div("ul.nav!")
    wrap_element( div("h4" , "Classes") )
    return @element
  end

end

class ClassView < RefView
  def initialize clazz
    super(clazz.name , clazz.object_id , 20 )
  end

  def ref_text
    @name
  end
end
