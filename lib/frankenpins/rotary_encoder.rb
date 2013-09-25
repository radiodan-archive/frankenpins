require 'unobservable'

module Frankenpins
  class RotaryEncoder
    include Unobservable::Support

    attr_event :changed

    def initialize(options)
      @pin_a, @pin_b = create_pins_from_options_hash!(options)

      @pin_a.watch { update }
      @pin_b.watch { update }

      @position = 0
      @last_val = 0
    end

    def update
      @pin_a.read
      msb = @pin_a.value

      @pin_b.read
      lsb = @pin_b.value

      encoded = (msb << 1) | lsb;
      sum = (@last_val << 2) | encoded;

      if(sum == 0b1101 || sum == 0b0100 || sum == 0b0010 || sum == 0b1011)
        @position += 1
        raise_event :changed, @position, :clockwise
      end
      if(sum == 0b1110 || sum == 0b0111 || sum == 0b0001 || sum == 0b1000)
        @position -= 1
        raise_event :changed, @position, :anticlockwise
      end

      @last_val = encoded
    end

    def on(event_name, &block)
      send(event_name).register(&block)
    end

    private
    def create_pins_from_options_hash!(options)
      options[:pull] = :up unless options.has_key?(:pull)
      pin_a_num = options.delete(:pin_a)
      pin_b_num = options.delete(:pin_b)
      pin_a = Frankenpins::Pin.new(options.merge(:pin => pin_a_num))
      pin_b = Frankenpins::Pin.new(options.merge(:pin => pin_b_num))
      return pin_a, pin_b
    end
  end
end
