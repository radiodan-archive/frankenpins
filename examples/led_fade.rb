require_relative '../lib/frankenpins'

# Create a new LED attached to Wiring Pi pin #6.
led = Frankenpins::LED.new(:pin => 6)

led.off

puts "1. Turn on/off over 1s"
led.on(:duration => 1)
sleep(2)
led.off(:duration => 1)

sleep(2)

puts "2. Turn on to brightness 10 over 1s"
led.brightness(10)
led.on(:duration => 1)
puts "   Turn off immediately"
sleep(1)
led.off

sleep(2)

puts "3. Turn to brightness 10 immediately"
led.brightness(10)
led.on
puts "   then transition to brightness 80 over 3s"
sleep(1)
led.brightness(80, :duration => 3)
puts "   then transition to brightness 10 over 3s"
sleep(1)
led.brightness(10, :duration => 3)
puts "   then turn off over 1s"
sleep(1)
led.off(:duration => 1)

sleep(2)

puts "4. Always transition over 2s"
led.default_duration = 2
puts "   on"
led.on  # over 2s
sleep(1)
puts "   20% brightness"
led.brightness(20)
sleep(1)
puts "   off"
led.off # over 2s

puts "Finished!"

Frankenpins.wait

