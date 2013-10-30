module Frankenpins
  class RGBLED

    attr_reader :red
    attr_reader :green
    attr_reader :blue

    def initialize(options={})
      @pin_nums = options.delete(:pins)
      @red   = LED.new( config_for_pin(@pin_nums[:red], options) )
      @green = LED.new( config_for_pin(@pin_nums[:green], options) )
      @blue  = LED.new( config_for_pin(@pin_nums[:blue], options) )
    end

    def on!(opts)
      if opts[:rgb]
        rgb(*opts[:rgb].map { |val| rgb_val_to_brightness(val) })
      elsif opts[:percent]
        rgb(*opts[:percent])
      end
    end

    def off!
      @red.off!
      @green.off!
      @blue.off!
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

    def rgb(r, g, b)
      @red.on!(:brightness   => r)
      @green.on!(:brightness => g)
      @blue.on!(:brightness  => b)
    end

    # e.g. 30/255 -> ?/100
    #      = scale(30, 255, 100)
    #      = 11.764705882
    def scale(val, domain, range)
      (val.to_f/domain.to_f) * range.to_f
    end
  end
end
