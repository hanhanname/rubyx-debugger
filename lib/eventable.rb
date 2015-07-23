# A simple event registering/triggering module to mix into classes.
# Events are stored in the `@events` ivar.
module Eventable

  # Register a handler for the given event name.
  #
  #   obj.on(:foo) { puts "foo was called" }
  #
  # @param [String, Symbol] name event name
  # @return handler
  def on(name, &handler)
    event_table[name] << handler
    handler
  end

  def off(name, handler)
    event_table[name].delete handler
  end

  def event_table
    return @event_table if @event_table
    @event_table = Hash.new { |hash, key| hash[key] = [] }
  end

  # Trigger the given event name and passes all args to each handler
  # for this event.
  #
  #   obj.trigger(:foo)
  #   obj.trigger(:foo, 1, 2, 3)
  #
  # @param [String, Symbol] name event name to trigger
  def trigger(name, *args)
    event_table[name].each { |handler| handler.call(*args) }
  end
end
