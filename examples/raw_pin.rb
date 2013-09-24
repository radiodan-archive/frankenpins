require_relative '../lib/frankenpins'

# Create a new Pin to control Wiring Pi pin #0
# We enable the built-in pull up/down resistors
# on the pin using the :pull => :up option, the
# default is :pull => :none
raw_pin = Frankenpins::Pin.new(:pin => 0, :pull => :up)
raw_pin.watch do |pin|
  puts "Value changed #{pin.value}"
end

puts raw_pin

puts "Waiting...."
Frankenpins.wait
