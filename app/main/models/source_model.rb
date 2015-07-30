class SourceModel < Volt::ArrayModel

  def instruction_changed old , ins
    return unless ins
    source = source_text ins.source
    if( self.length > 0)
      return if self.last._name == source
      self.last._class_name = "inactive"
    end
    self << { :name => source.to_s , :class_name => "bright" }
    #puts "sources #{self.length}"
    self.delete_at(0) if( self.length > 5)
  end

  def source_text source
    if source.is_a? Virtual::Instruction
      return source.class.name
    else
      return "Method: #{source.name}"
    end
  end

end
