require 'opal'
require 'opal-jquery'
require "json"
require 'opal-react'

require "class_view"
require "register_view"
require "source_view"

Document.ready? do  # Document.ready? is a opal-jquery method.
  React.render( React.create_element( Debugger),  Element['#content']    )
end

class Debugger

  include React::Component
#  required_param :url
  define_state sources: JSON.from_object(`window.initial_sources`)

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
    div class: "sourceBox" do
      h1 { "Sources" }
      ClassView sources: sources
      RegisterView submit_source: lambda { |source| sources! << sourceAuthor}
    end
  end
end
