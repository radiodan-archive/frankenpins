require_relative '../lib/things'

Things.watch :pin => 0, :pull => :up do |pin|
  puts "Value changed #{pin.value}"
end

Things.wait
