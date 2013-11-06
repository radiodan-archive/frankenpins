module Frankenpins
  class RGBLED

    attr_reader :red
    attr_reader :green
    attr_reader :blue

    attr_reader :default_duration
    attr_writer :default_duration

    def initialize(options={})
      @is_on = false
      @pin_nums = options.delete(:pins)
      @red   = LED.new( config_for_pin(@pin_nums[:red], options) )
      @green = LED.new( config_for_pin(@pin_nums[:green], options) )
      @blue  = LED.new( config_for_pin(@pin_nums[:blue], options) )

      @default_duration = nil
    end

    def on(opts={})
      [@red, @green, @blue].map { |led| led.on(opts) }
      rgb(opts[:rgb]) if opts[:rgb]
      percentage(opts[:percent]) if opts[:percent]
      @is_on = true
    end

    def off(opts={})
      [@red, @green, @blue].map { |led| led.off(opts) }
      @is_off = true
    end

    def rgb(rgb, opts={})
      write_colours(*rgb.map { |val| rgb_val_to_brightness(val) }, opts)
    end

    def percentage(rgb, opts={})
      write_colours(*rgb, opts)
    end

    private
    def rgb_val_to_brightness(val)
      scale(val, 255, 100).to_i
    end

    def config_for_pin(num, options)
      opts = options.clone
      opts[:pin] = num
      opts
    end

    def write_colours(r, g, b, opts={})
      duration = opts[:duration] || @default_duration
      @red.brightness(r, :duration => duration)
      @green.brightness(g, :duration => duration)
      @blue.brightness(b, :duration => duration)
    end

    # e.g. 30/255 -> ?/100
    #      = scale(30, 255, 100)
    #      = 11.764705882
    def scale(val, domain, range)
      (val.to_f/domain.to_f) * range.to_f
    end
  end
end
