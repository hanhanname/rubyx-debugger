class BlocksModel < Volt::ArrayModel

  def instruction_changed old , ins
    self.last._class_name = "inactive" if( self.length > 0)
    self << { :name => ins.to_s , :class_name => "bright" }
    #puts "block #{self.length}"
    self.delete_at(0) if( self.length > 5)
  end

end
