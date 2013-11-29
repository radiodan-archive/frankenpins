require 'ostruct'
require 'thread'
Thread.abort_on_exception = true

require_relative './led_transition'
require_relative './transition_queue'

module Frankenpins
  class LED

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

      @queue.push(LEDTransition.new(props))
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
