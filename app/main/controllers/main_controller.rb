# By default Volt generates this controller for your Main component
require "salama"

if RUBY_PLATFORM == 'opal'
  require "main/lib/main_view"
end

module Main
  class MainController < Volt::ModelController

    def index
      MainView.new()
    end

    def about
      promise = ParseTask.parse(1).then do |result|
        puts result
      end.fail do |error|
        puts "Error: #{error}"
      end
    end

    private

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
