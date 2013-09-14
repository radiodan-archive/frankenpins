require_relative '../lib/frankenpins'

button = Frankenpins::Button.new(:pin => 0, :pull => :up)

button.on :pressed do
  puts "Button pressed"
end

button.on :released do
  puts "Button released"
end

button.on :changed do
  puts "Button changed"
end

Frankenpins.wait
