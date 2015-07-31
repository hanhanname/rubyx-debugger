module Main
  class ClassesController < Volt::ModelController

    def initialize *args
      super(*args)

      page._classes!.clear
      Virtual.machine.space.classes.each do |name , claz|
        next if [:Kernel,:Module,:MetaClass,:BinaryCode].index name
        c = Volt::Model.new :name => name
        page._classes << c
      end
    end

  end
end
