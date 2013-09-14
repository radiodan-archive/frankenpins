require 'bundler/setup'
require 'wiringpi2'
require_relative '../lib/things'

io = WiringPi::GPIO.new
io.pin_mode(0, 0)


io.interrupt(0, :rising_edge) do |value|
  puts "Value changed #{value}"
end

Things.wait
