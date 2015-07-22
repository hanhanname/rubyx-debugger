require 'opal'
require 'opal-jquery'
require "json"
require 'opal-react'

require "class_view"
require "register_view"
require "source_view"
require "block_view"

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
    div do
      ClassView classes: { :class1 => "Object"}
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
