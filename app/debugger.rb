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

  def render
    div :class => "container" do
      div :class => :row do
        div :class => "col-md-1" do
          ClassView classes: Virtual.machine.space.classes
        end
        div :class => "col-md-11" do
          div :class => "row" do
            div :class => "col-md-4" do
              "Future one"
            end
            div :class => "col-md-4" do
              "Future two"
            end
            div :class => "col-md-4" do
              BlockView block: [ "block 1" , "block 2"]
            end
          end
          RegisterView registers: ["r1" , "r2"]
        end
      end
    end

  end
end
