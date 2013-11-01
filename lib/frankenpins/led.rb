module Frankenpins
  class LED

    def initialize(options={})
      options[:direction] = :out
      @pin = Frankenpins::Pin.new(options)
      @using_pwm = false
      @pwm_range = 100
      @pwm_increment_in_secs = 0.01
    end

    def brightness=(value)
      pwm_write(value)
    end

    def on!(opts={:brightness => nil, :duration => nil})
      if opts[:duration]
        fade_for_duration(opts[:duration])
      elsif opts[:brightness]
        self.brightness = opts[:brightness]
      elsif @using_pwm
        self.brightness = @pwm_range
      else
        digital_write(true)
      end
    end

    def off!(opts={:duration => nil})
      if opts[:duration]
        fade_for_duration(opts[:duration], :down)
      elsif @using_pwm
        self.brightness = 0
      else
        digital_write(false)
      end
    end

    private

    def digital_write(value)
      @pin.write(value)
    end

    def use_pwm!
      @pin.io.soft_pwm_create(@pin.wiring_pin, 0, @pwm_range) unless @using_pwm
      @using_pwm = true
    end

    def pwm_write(value)
      use_pwm!
      @pin.io.soft_pwm_write(@pin.wiring_pin, value.to_i)
    end

    def fade_for_duration(duration_in_secs, direction=:up)
      fade_for_duration_in_increments_of(duration_in_secs, @pwm_increment_in_secs, direction)
    end

    def fade_for_duration_in_increments_of(duration_in_secs, increment_time_in_sec, direction)
      increment = increment_time_in_sec.to_f / duration_in_secs.to_f
      steps = (duration_in_secs.to_f / increment_time_in_sec.to_f).to_i

      brightness_value = direction == :up ? 0 : @pwm_range

      steps.times.each do
        if direction == :up
          brightness_value = brightness_value + (increment * @pwm_range)
        else
          brightness_value = brightness_value - (increment * @pwm_range)
        end

        self.brightness = brightness_value
        sleep(increment_time_in_sec)
      end
    end

  end
end
