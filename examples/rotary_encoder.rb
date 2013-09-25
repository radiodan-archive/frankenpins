require_relative '../lib/frankenpins'

# Set up a rotary encoder that is connected to
# Wiring Pi pins #4 and #5 using a :pull => :up
# internal resistor by default. If you'd like to
# use external resistors on both pins, pass the
# option :pull => :none
encoder = Frankenpins::RotaryEncoder.new(:pin_a => 4, :pin_b => 5)

encoder.on :changed do |pos, direction|
  puts "position: #{pos}, direction: #{direction}"
end

# Use the Button class to watch the switch part of the
# encoder, push down to activate
button = Frankenpins::Button.new(:pin => 1)
button.on :pressed do
  puts "Button pressed"
end

puts "Rotate or push...."
Frankenpins.wait
