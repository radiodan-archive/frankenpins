require_relative '../lib/things'

Things.watch :pin => 17 do |pin|
  puts "Value changed #{pin.value}"
end

Things.wait
