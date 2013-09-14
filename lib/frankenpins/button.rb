require 'unobservable'

module Frankenpins
  class Button
    include Unobservable::Support

    attr_event :pressed
    attr_event :released
    attr_event :changed

    def initialize(options)
      @pin = Frankenpins::Pin.new(options)
      @pin.watch do |pin|
        if pin.value == 0
          raise_event :pressed
        elsif pin.value == 1
          raise_event :released
        end

        # Always fire a changed event
        raise_event :changed
      end
    end

    def on(event_name, &block)
      send(event_name).register(&block)
    end
  end
end
