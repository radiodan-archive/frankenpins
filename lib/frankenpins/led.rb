module Frankenpins
  class LED
    include Unobservable::Support

    attr_event :on
    attr_event :off
    attr_event :changed

    def initialize(options={})
      options[:direction] = :out
      @pin = Frankenpins::Pin.new(options)
    end

    def on!
      @pin.write(true)
    end

    def off!
      @pin.write(false)
    end
  end
end
