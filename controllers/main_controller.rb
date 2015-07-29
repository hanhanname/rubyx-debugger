
require "opal/parser" # to get eval to work

$LOAD_PATH.unshift("/Users/raisa/salama/salama-debugger/app/main/lib")

require "salama"

Virtual::Machine.boot

module Main
  class MainController < Volt::ModelController

    def index
      page._registers!.clear
      page._classes!.clear
      page._objects!.clear
      page._source = InstructionModel.new nil
      page._block = BlockModel.new nil
      fill_regs
      parse_and_fill
    end

    def about

    end

    private

    def parse_and_fill
      ParseTask.parse(1).then do |result|
        is = Ast::Expression.from_basic(result)
        Virtual::Compiler.compile( is , Virtual.machine.space.get_main )
        Virtual.machine.run_before "Register::CallImplementation"
        fill_classes
      end.fail do |error|
        raise "Error: #{error}"
      end
    end
    def fill_classes
      Virtual.machine.space.classes.each do |name , claz|
        next if [:Kernel,:Module,:MetaClass,:BinaryCode].index name
        c = Volt::Model.new :name => name
        page._classes << c
      end
      b = Virtual.machine.init
      page._block = BlockModel.new b
      page._source = InstructionModel.new b.codes.first.source
    end
    def fill_regs
      register_names = (0..8).collect {|i| "r#{i}"}
      register_names.each do |reg_name|
        reg = Volt::Model.new :name => reg_name
        page._registers << reg
      end
    end
    # The main template contains a #template binding that shows another
    # template.  This is the path to that template.  It may change based
    # on the params._component, params._controller, and params._action values.
    def main_path
      "#{params._component || 'main'}/#{params._controller || 'main'}/#{params._action || 'index'}"
    end

    # Determine if the current nav component is the active one by looking
    # at the first part of the url against the href attribute.
    def active_tab?
      url.path.split('/')[1] == attrs.href.split('/')[1]
    end
  end
end
