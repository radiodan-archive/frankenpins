module Frankenpins
  # A transition of the brightness of
  # the LED.
  # Transitions encode all the info
  # necessary to change the state
  class LEDTransition < OpenStruct

    def perform!
      if type == :digital
        digital_write(value)
      elsif duration
        transition!
      elsif type == :pwm
        pwm_write(value)
      end
    end

    def transition!
      duration_in_secs = duration
      from_value       = from
      to_value         = to
      increment_time_in_sec = 0.01

      range = to_value - from_value

      increment = increment_time_in_sec.to_f / duration_in_secs.to_f
      steps = (duration_in_secs.to_f / increment_time_in_sec.to_f).to_i

      brightness_value = from_value

      steps.times.each do
        brightness_value = brightness_value + (increment * range)
        pwm_write(brightness_value)
        sleep(increment_time_in_sec)
      end
    end

    def digital_write(value)
      pin.write(value)
    end

    def pwm_write(value)
      # puts "pwm_write(#{pin.wiring_pin}, #{value.to_i})"
      pin.io.soft_pwm_write(pin.wiring_pin, value.to_i)
    end
  end
end
