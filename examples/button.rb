require_relative '../lib/frankenpins'

button = Frankenpins::Button.new(:pin => 0, :pull => :up)
button.on :pressed do
  puts "Button pressed"
end

Frankenpins.wait
