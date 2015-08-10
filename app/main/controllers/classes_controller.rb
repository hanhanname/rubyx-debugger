module Main
  class ClassesController < Volt::ModelController

    def initialize *args
      super(*args)

      page._classes!.clear
      all = []
      Virtual.machine.space.classes.each do |name , claz|
        next if [:Kernel,:Module,:MetaClass,:BinaryCode].index name
        all << name
      end
      all.sort.each do |name|
        c = Volt::Model.new :name => name
        page._classes << c
      end
    end

    def variables(clas_model)
      self.variables(clas_model.name)
    end

    def self.variables(clas_name)
      layout = Virtual.machine.space.get_class_by_name(clas_name).object_layout
      vars = []
      layout.object_instance_names.each do |name|
        vars << name
      end
      vars
    end
  end
end
