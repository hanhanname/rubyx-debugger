class BlocksModel < Volt::ArrayModel

  def instruction_changed old , ins
    self.last._class_name = "" if( page._blocks.length > 0)
    self << { :name => ins.to_s , :class_name => "active" }
  end

end
