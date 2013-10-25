require_relative '../lib/frankenpins'

# Create a new LED attached to Wiring Pi pin #6.
led = Frankenpins::LED.new(:pin => 6)

# Turn the LED on
puts "Turning on"
led.on!

# Wait 5 seconds
sleep(5)

# Turn the LED off
puts "Turning off"
led.off!
