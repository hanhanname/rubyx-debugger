module Main
  class StatusController < Volt::ModelController
    def initialize app , context
      super(app , context)
      @interpreter = attrs.interpreter
      self.model = Volt::Model.new
      update_interpreter
    end

    def tick
      @interpreter.tick
      update_interpreter
    end
    def update_interpreter
      self._clock = @interpreter.clock
      self._state = @interpreter.state
      self._stdout = @interpreter.stdout
      self._link = @interpreter.link.to_s
      page._method_name = method_name
      page._block_name = @interpreter.block ? @interpreter.block.name : " "
    end

    def method_name
      bl = @interpreter.block
      return " " unless bl
      return bl.method if bl.method.is_a? String
      "#{bl.method.for_class.name}.#{bl.method.name}"
    end

  end
end
