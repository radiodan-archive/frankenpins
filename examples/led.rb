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
led.on!(:brightness => 20)
sleep(2)

puts "Turning to the LED to 40% brightness"
led.on!(:brightness => 40)
sleep(2)

puts "Turning to the LED to 60% brightness"
led.on!(:brightness => 60)
sleep(2)

puts "Turning to the LED to 80% brightness"
led.on!(:brightness => 80)

sleep(2)

puts "Turn LED off"
led.off!
