if RUBY_PLATFORM == 'opal'
  require "native"
end

module Main
  class ObjectsController < Volt::ModelController

    def index_ready
      container = Native(self.container).querySelector("ul")
      return unless container
      puts "li " + container.innerHTML + " lo"
#      red = -> (event) {  container.style.backgroundColor = "red" }
      red = -> (event) {  puts container.tagName }
      container.addEventListener("mouseenter" , red)
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
