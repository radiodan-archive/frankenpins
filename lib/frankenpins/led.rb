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

    def use_pwm!
      @pin.io.soft_pwm_create(@pin.wiring_pin, 0, 100) unless @using_pwm
      @using_pwm = true
    end

    def brightness=(value)
      sanitised_brightness = (value * 100).to_i
      use_pwm!
      @pin.io.soft_pwm_write(@pin.wiring_pin, sanitised_brightness)
    end

    def on!(opts={:brightness => nil, :duration => nil})
      # brightness should be a value from 0 - 1
      if opts[:duration]
        fade_for_duration(opts[:duration])
      elsif opts[:brightness]
        self.brightness = opts[:brightness]
      elsif @using_pwm
        self.brightness = 1
      else
        @pin.write(true)
      end
    end

    def off!(opts={:duration => nil})
      if opts[:duration]
        fade_for_duration(opts[:duration], :down)
      elsif @using_pwm
        self.brightness = 0
      else
        @pin.write(false)
      end
    end

    private
    def fade_for_duration(duration_in_secs, direction=:up)
      fade_for_duration_in_increments_of(duration_in_secs, 0.01, direction)
    end

    def fade_for_duration_in_increments_of(duration_in_secs, increment_time_in_sec, direction)
      increment = increment_time_in_sec.to_f / duration_in_secs.to_f
      steps = (duration_in_secs.to_f / increment_time_in_sec.to_f).to_i

      brightness_value = direction == :up ? 0 : 1

      steps.times.each do
        if direction == :up
          brightness_value = brightness_value + increment
        else
          brightness_value = brightness_value - increment
        end

        self.brightness = brightness_value
        sleep(increment_time_in_sec)
      end
    end

  end
end
