require 'wiringpi2'

module Frankenpins
  class WiringPiSingleton
    @@gpio_instance = WiringPi::GPIO.new

    def self.gpio_instance
      @@gpio_instance
    end
  end
end