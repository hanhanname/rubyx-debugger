if RUBY_PLATFORM == 'opal'
  require "native"
end

module Main
  class ObjectsController < Volt::ModelController

    def index_ready
      container = Native(self.container).querySelector("ul")
      all = container.querySelectorAll("a")
      len = all.length - 1
      while len >= 0
        puts "li #{len}" + all.item(len).innerHTML + " lo"
        len = len - 1
      end
#      red = -> (event) {  container.style.backgroundColor = "red" }
      red = -> (event) {  puts container.innerHTML }
      container.addEventListener("mouseenter" , red)
    end

    def marker id
      var = Virtual.machine.objects[id]
      if var.is_a? String
        str "Wo"
      else
        str = var.class.name.split("::").last[0,2]
      end
      str + " : #{id.to_s}"
    end

    def class_header(id)
      object = Virtual.machine.objects[id]
      return "" unless object
      clazz = object.class.name.split("::").last
      "#{clazz}:#{id}"
    end

    def content(id)
      object = Virtual.machine.objects[id]
      fields = []
      if object and ! object.is_a?(String)
        object.get_instance_variables.each do |variable|
          f = object.get_instance_variable(variable)
          fields << ["#{variable} : #{marker(f.object_id)}" , f.object_id]
        end
      end
      fields
    end

    def is_object?( id )
      Virtual.machine.objects[id] != nil
    end

  end
end
