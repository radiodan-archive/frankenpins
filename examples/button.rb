require_relative '../lib/frankenpins'

# Create a new Button attached to Wiring Pi pin #0.
# By default, the built-in pull-up resistor will be used.
# To use your own external resistor, pass in :pull => :none
# as an option
button = Frankenpins::Button.new(:pin => 0)

button.when :pressed do
  puts "Button pressed"
end

button.when :released do
  puts "Button released"
end

button.when :changed do
  puts "Button changed"
end

puts "Push the button..."
Frankenpins.wait
