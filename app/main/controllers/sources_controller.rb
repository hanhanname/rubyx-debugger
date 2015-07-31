module Main
  class SourcesController < Volt::ModelController
    def initialize *args
      super(*args)

      sources = SourceModel.new
      page._sources = sources
      @volt_app.interpreter.register_event(:instruction_changed,  sources)
    end

  end
end
