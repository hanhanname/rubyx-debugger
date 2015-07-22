require 'opal'
require 'browser'
require 'opal-jquery'
require "json"
require 'opal-react'

Document.ready? do  # Document.ready? is a opal-jquery method.  The block will run when doc is loaded

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

class ClassView

  include React::Component

  required_param :sources, type: [Hash]

  def render
    div class: "sourceList" do
      sources.each do |source|
        Source author: source[:author], text: source[:text]
      end
    end
  end

end

class RegisterView

  include React::Component
  required_param :submit_source, type: Proc

  define_state :author, :text

  def render
    div do
      div do
        "Author: ".span
        input(type: :text, value: author, placeholder: "Your name", style: {width: "30%"}).
          on(:change) { |e| author! e.target.value }
      end
      div do
        div(style: {float: :left, width: "50%"}) do
          textarea(value: text, placeholder: "Say something...", style: {width: "90%"}, rows: 10).
            on(:change) { |e| text! e.target.value }
        end
        div(style: {float: :left, width: "50%"}) do
          text
        end
      end
      button { "Post" }.on(:click) { submit_source :author => (author! ""), :text => (text! "") }
    end
  end
end

class Source

  include React::Component

  required_param :author
  required_param :text

  def render
    div class: "source" do
      h2(class: "sourceAuthor") { author }
      div do
        text
      end
    end
  end

end
