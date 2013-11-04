module Frankenpins
  class LED

    attr_reader :default_duration
    attr_writer :default_duration

    def initialize(options={})
      options[:direction] = :out
      @pin = Frankenpins::Pin.new(options)
      @using_pwm = false
      @pwm_range = 100
      @pwm_increment_in_secs = 0.01
      @brightness = 0
      @is_on = false
      @default_duration = nil

      @debug = false
    end

    def brightness(value, opts={:duration => nil})
      duration = opts[:duration] || @default_duration
      if duration
        transition(
          :duration => duration,
          :from     => @brightness,
          :to       => value
        )
      else
        change_brightness(value)
      end
    end

    def on(opts={:duration => nil})
      duration = opts[:duration] || @default_duration
      @is_on = true
      if duration
        brightness(100, :duration => duration)
      elsif !@using_pwm
        digital_write(true)
      else
        brightness(@brightness)
      end
    end

    def on?
      @is_on
    end

    def off?
      !@is_on
    end

    def off(opts={:duration => nil})
      duration = opts[:duration] || @default_duration
      if duration
        brightness(0, :duration => duration)
      elsif @using_pwm
        brightness(0)
      else
        digital_write(false)
      end

      @is_on = false
    end

    private

    def change_brightness(value)
      pwm_write(value) if on?
      @brightness = value
    end

    def digital_write(value)
      puts "digital_write(#{value})" if @debug
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

    def transition(properties)
      duration_in_secs = properties[:duration]
      from_value       = properties[:from]
      to_value         = properties[:to]

      range = to_value - from_value
      increment_time_in_sec = @pwm_increment_in_secs

      increment = increment_time_in_sec.to_f / duration_in_secs.to_f
      steps = (duration_in_secs.to_f / increment_time_in_sec.to_f).to_i

      brightness_value = from_value

      steps.times.each do
        brightness_value = brightness_value + (increment * range)
        change_brightness(brightness_value)
        sleep(increment_time_in_sec)
      end
    end

  end
end
