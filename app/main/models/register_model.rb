class RegisterModel < Volt::Model
  field :name
  field :value
  field :fields

  def register_changed reg , old , value
    reg = reg.symbol unless reg.is_a? Symbol
    return unless reg == name
    self.value = value
    calc_fields
  end

  def object_changed reg
    reg = reg.symbol unless reg.is_a? Symbol
    return unless reg == name
    #puts "Object changed in #{reg}"
    calc_fields
  end

  def calc_fields
    #puts "My id #{objects_id} , #{objects_id.class}"
    object = Virtual.machine.objects[value]
    self.fields.clear
    if object and ! object.is_a?(String)
      clazz = object.class.name.split("::").last
      #puts "found #{clazz}"
      self.fields << "#{clazz}:#{object.internal_object_length}"
      self.fields << object.get_layout
      object.get_instance_variables.each do |variable|
        f = object.get_instance_variable(variable)
        self.fields << f
      end
    end
  end

end
