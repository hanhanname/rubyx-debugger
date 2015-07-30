class RegisterModel < Volt::Model
  field :name
  field :value

  def register_changed reg , old , ins
    self.last._class_name = "" if( page._blocks.length > 0)
    self << { :name => ins.to_s , :class_name => "active" }
  end

end
