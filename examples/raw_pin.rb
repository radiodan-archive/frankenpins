require_relative '../lib/frankenpins'

raw_pin = Frankenpins::Pin.new(:pin => 0, :pull => :up)
raw_pin.watch do |pin|
  puts "Value changed #{pin.value}"
end

puts raw_pin

puts "Waiting...."
Frankenpins.wait