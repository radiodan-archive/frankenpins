require_relative '../lib/frankenpins'

# Create a new LED attached to Wiring Pi pin #6.
led = Frankenpins::LED.new(:pin => 6)

# Simple LED examples

puts "Turning LED on"
led.on!

# Do nothing for 2 seconds
sleep(2)

puts "Turning LED off"
led.off!

sleep(2)

# Variable brightness using PWM

puts "Turning to the LED to 20% brightness"
led.on!(:brightness => 0.2)
sleep(2)

puts "Turning to the LED to 40% brightness"
led.on!(:brightness => 0.4)
sleep(2)

puts "Turning to the LED to 60% brightness"
led.on!(:brightness => 0.6)
sleep(2)

puts "Turning to the LED to 80% brightness"
led.on!(:brightness => 0.8)

sleep(2)

# Fade the LED off over a second
puts "Turning off"
led.off!
