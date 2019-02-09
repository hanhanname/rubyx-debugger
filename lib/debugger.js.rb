
require "opal"
require "opal-parser"
require 'opal/compiler'

require 'browser'
require 'browser/http'
require 'native'
require "rubyx"
require "ast"
require "util/eventable"
require "risc/interpreter"
# the base, our own mini framework, allows for child and parent views and handles updates
require "base/list_view"
# each seperate view is in it's own class.
require "views/left_view"
require "views/status_view"
require "views/vool_view"
require "views/mom_view"
require "views/risc_view"
require "views/registers_view"
class Bignum
end
class String
  def codepoints
    arr = []
    one = nil
    self.each_byte do |c|
      if( one )
        arr << (one + c * 256)
        one = nil
      else
        one = c
      end
    end
    arr
  end
end
module RubyX
  def self.debugger_options
    { parfait: {factory: 50} }
  end
end
class MainView < ListView

  def initialize
    compiler = RubyX::RubyXCompiler.new(RubyX.debugger_options)
    input = "class Space;def main(arg); return 1; end; end"
    linker = compiler.ruby_to_binary(input , :interpreter)
    @interpreter = Risc::Interpreter.new(linker)
    super( [LeftView.new(@interpreter)  ,
            VoolView.new(@interpreter)  ,
            MomView.new(@interpreter)  ,
            RiscView.new(@interpreter)     ,
            StatusView.new(@interpreter)     ,
            RegistersView.new(@interpreter) ] )
  end

end

view = MainView.new()
view.draw.append_to($document.body)
