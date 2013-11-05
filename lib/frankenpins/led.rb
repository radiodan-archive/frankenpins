require 'ostruct'
require 'thread'
Thread.abort_on_exception = true

module Frankenpins
  class LED

    # A transition of the brightness of
    # the LED.
    # Transitions encode all the info
    # necessary to change the state
    class Transition < OpenStruct

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

    # A transition queue
    # Items added to the queue are
    # executed in order
    class TransitionQueue
      def initialize
        @queue = Queue.new
        @debug = false
      end

      def push(transition)
        puts "E: #{transition.type} #{transition}" if @debug
        @queue.push(transition)
      end

      def start!
        Thread.new do
          loop do
            transition = @queue.pop
            puts "D: #{transition.type} #{transition}" if @debug
            transition.perform!
          end
        end
      end
    end

    attr_reader :default_duration
    attr_writer :default_duration

    def initialize(options={})
      options[:direction] = :out
      @pin = Frankenpins::Pin.new(options)

      @using_pwm = false
      @pwm_max   = 100

      @is_on = false
      @brightness = 0

      # TODO: Should be 0?
      @default_duration = nil

      @queue = TransitionQueue.new
      @queue.start!
    end

    def on(opts={})
      brightness(100, opts)
      @is_on = true
    end

    def off(opts={})
      brightness(0, opts)
      @is_on = false
    end

    def brightness(value, opts={})

      duration = opts[:duration] || @default_duration

      if value != 100 || value != 0 || duration
        use_pwm!
      end

      props = { :pin => @pin }

      if duration
        props[:type]     = :pwm
        props[:from]     = @brightness
        props[:to]       = value
        props[:duration] = duration
      elsif @using_pwm
        props[:type]  = :pwm
        props[:value] = value
      else
        props[:type]  = :digital
        props[:value] = false if @brightness == 0
        props[:value] = true  if @brightness == 100
      end

      @queue.push(Transition.new(props))
      @brightness = value
    end

    private
    def use_pwm!
      if @using_pwm == false
        @pin.io.soft_pwm_create(@pin.wiring_pin, 0, @pwm_max)
        @using_pwm = true
      end
    end
  end
end
