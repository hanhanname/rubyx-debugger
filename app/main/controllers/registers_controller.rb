module Main
  class RegistersController < Volt::ModelController

    def initialize *args
      super(*args)
      self.model = []
      init_registers
    end


    def init_registers
      @volt_app.interpreter.registers.each do |reg , val|
        r = RegisterModel.new( :name => reg , :value => val)
        self.model <<  r
        @volt_app.interpreter.register_event(:register_changed,  r)
        @volt_app.interpreter.register_event(:object_changed,  r)
        r.register_changed( reg , nil , @volt_app.interpreter.registers[reg])
      end
    end

    def marker var
      return "Wo" if var.is_a? String
      var.class.name.split("::").last[0,2]
    end

  end
end
