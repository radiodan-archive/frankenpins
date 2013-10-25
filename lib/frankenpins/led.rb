module Frankenpins
  class LED
    include Unobservable::Support

    attr_event :on
    attr_event :off
    attr_event :changed

    def initialize(options={})
      options[:direction] = :out
      @pin = Frankenpins::Pin.new(options)
      @using_pwm = false
    end

    def on!(opts={:brightness => nil})
      # brightness should be a value from 0 - 1
      if opts[:brightness]
        brightness = (opts[:brightness] * 100).to_i
        @pin.io.soft_pwm_create(@pin.wiring_pin, 0, 100)
        @pin.io.soft_pwm_write(@pin.wiring_pin, brightness)
        @using_pwm = true
      elsif @using_pwm
        @pin.io.soft_pwm_write(@pin.wiring_pin, 100)
      else
        @pin.write(true)
      end
    end

    def off!(opts={:duration => nil})
      if @using_pwm
        @pin.io.soft_pwm_write(@pin.wiring_pin, 0)
      else
        @pin.write(false)
      end
    end

  end
end
