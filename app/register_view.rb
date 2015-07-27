
class RegisterView

  include React::Component
  required_param :interpreter
  required_param :register

  define_state :objects_id
  define_state :fields => []

  before_mount do
    interpreter.register_event(:register_changed,  self)
    register_changed( register , nil , interpreter.registers[register])
  end

  def register_changed reg , old , value
    return unless reg == register
    objects_id! value
    calc_fields
  end

  def calc_fields
    #puts "My id #{objects_id} , #{objects_id.class}"
    object = Virtual.machine.objects[objects_id]
    if object and ! object.is_a?(String)
      has_fields = []
      clazz = object.class.name.split("::").last
      #puts "found #{clazz}"
      has_fields << clazz
      object.get_instance_variables.each do |variable|
        f = object.get_instance_variable(variable)
        has_fields << f
      end
      fields! has_fields
    end
  end

  def render
    div.register_view do
      div do
        objects_id.to_s
      end
      fields.each do |attribute|
        div.col_md_12 do
          "#{marker(attribute)} - #{attribute.object_id}".span
        end
      end
    end
  end

  def marker var
    var.class.name.split("::").last[0]
  end
end
