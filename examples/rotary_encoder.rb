require_relative '../lib/frankenpins'

encoder = Frankenpins::RotaryEncoder.new(:pin_a => 4, :pin_b => 5, :pull => :up)

encoder.on :changed do |pos, old_pos, direction|
  puts pos
end

# Button
button = Frankenpins::Button.new(:pin => 1, :pull => :up)
button.on :changed do
  puts "Button"
end

puts "Waiting...."
Frankenpins.wait
