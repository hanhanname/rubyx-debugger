module Main
  class RegistersController < Volt::ModelController

    def initialize app , context
      super(app , context)
      self.model = []
      init_registers attrs.interpreter
    end

    def init_registers interpreter
      interpreter.registers.each do |reg , val|
        r = RegisterModel.new( :name => reg , :value => val)
        self.model <<  r
        interpreter.register_event(:register_changed,  r)
        interpreter.register_event(:object_changed,  r)
        r.register_changed( reg , nil , interpreter.registers[reg])
      end
    end

    def marker var
      return "W" if var.is_a? String
      var.class.name.split("::").last[0]
    end

  end
end
