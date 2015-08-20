class StatusView < ElementView

   def initialize interpreter
     @interpreter = interpreter
   end

   def draw
     DOM do |dom|
       dom.div.status_view do
         dom.h4 {"Interpreter"}
         dom.span "Instruction #{@interpreter.clock}"
         dom.button { "Next"}
         dom.span "State #{@interpreter.state}"
         dom.br{""}
         dom.span{ "Link #{@interpreter.link}"}
         dom.br{"Stdout"}
         dom.span { @interpreter.stdout}
       end
     end
   end

 end
