require_relative '../lib/frankenpins'

# Create a new LED attached to Wiring Pi pin #6.
led = Frankenpins::LED.new(:pin => 6)

led.off

while true do
  puts "Fade the LED on over 1 second"
  led.on(:duration => 1)

  puts "Fade the LED off over 1 second"
  led.off(:duration => 1)

  sleep(1)
end
