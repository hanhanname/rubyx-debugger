require 'opal'
require 'opal-jquery'
require "opal/parser"
require "json"
require 'opal-react'

require "salama"
require "class_view"
require "register_view"
require "source_view"
require "block_view"
require "interpreter"

Virtual.machine.boot

Document.ready? do  # Document.ready? is a opal-jquery method.
  React.render( React.create_element( Debugger),  Element['#content']    )
end

class Debugger

  include React::Component
#  required_param :url
#  define_state sources: JSON.from_object(`window.initial_sources`)

  # before_mount do
  #   HTTP.get(url) do |response|
  #     if response.ok?
  #       sources! JSON.parse(response.body)
  #     else
  #       puts "failed with status #{response.status_code}"
  #     end
  #   end
  # end
  def initialize
    @interpreter = Interpreter.new
  end

  def render
    div.container do
      div.row do
        div.col_md_1 do
          ClassView classes: Virtual.machine.space.classes
        end
        div.col_md_11 do
          div.row do
            div.col_md_4 do
              "Future one"
            end
            div.col_md_4 do
              "Future two"
            end
            div.col_md_4 do
              BlockView block: [ "block 1" , "block 2"]
            end
          end
          RegisterView registers: @interpreter.registers
        end
      end
    end

  end
end
