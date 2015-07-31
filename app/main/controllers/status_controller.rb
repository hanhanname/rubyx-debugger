module Main
  class StatusController < Volt::ModelController

    def initialize *args
      super(*args)
      self.model = Volt::Model.new
      update_interpreter
    end

    def tick
      @volt_app.interpreter.tick
      update_interpreter
    end
    def update_interpreter
      self._clock = @volt_app.interpreter.clock
      self._state = @volt_app.interpreter.state
      self._stdout = @volt_app.interpreter.stdout
      self._link = @volt_app.interpreter.link.to_s
      page._method_name = method_name
      page._block_name = @volt_app.interpreter.block ? @volt_app.interpreter.block.name : " "
    end

    def method_name
      bl = @volt_app.interpreter.block
      return " " unless bl
      return bl.method if bl.method.is_a? String
      "#{bl.method.for_class.name}.#{bl.method.name}"
    end

  end
end
