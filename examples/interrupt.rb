require 'bundler/setup'
require 'wiringpi2'

INPUT = 0
PUD_UP = 2
INT_EDGE_BOTH = 3

pin = 0

io = WiringPi::GPIO.new
io.pin_mode(pin,INPUT)
io.pullUpDnControl(pin, PUD_UP)
io.wiringpi_isr(pin, INT_EDGE_BOTH) do
  puts "in block"
end

puts "before while"

while (true)
  puts io.digital_read(pin)
  sleep(0.5)
end
