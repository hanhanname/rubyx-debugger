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

    def content(id)
      object = Virtual.machine.objects[id]
      fields = []
      if object and ! object.is_a?(String)
        clazz = object.class.name.split("::").last
        fields << ["#{clazz}:#{object.internal_object_length}" , 0]
        fields << ["--------------------" ,  0 ]
        object.get_instance_variables.each do |variable|
          f = object.get_instance_variable(variable)
          fields << ["#{variable} : #{marker(f)} : #{f.object_id}" , f.object_id]
        end
      end
      fields
    end

    def is_object?( id )
      Virtual.machine.objects[id] != nil
    end
  end
end
