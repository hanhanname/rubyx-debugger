module Main
  class BlocksController < Volt::ModelController

    def initialize *args
      super(*args)
      blocks = BlocksModel.new
      page._blocks = blocks
      @volt_app.interpreter.register_event(:instruction_changed,  blocks)
    end

  end
end
