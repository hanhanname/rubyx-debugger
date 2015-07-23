require 'opal'
require "opal/parser"
require 'opal-jquery'
require "json"
require 'opal-react'

require "salama"
require "class_view"
require "register_view"
require "source_view"
require "block_view"
require "interpreter"
require "debugger"

Document.ready? do  # Document.ready? is a opal-jquery method.
  React.render( React.create_element( Debugger ),  Element['#content']    )
end
