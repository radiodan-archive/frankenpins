require_relative '../lib/frankenpins'

# Create a new LED attached to Wiring Pi pin #6.
led = Frankenpins::RGBLED.new(:pins => { :green => 5, :red => 4, :blue => 1 })

colours = {
  :purple => [80 , 0  , 80   ],
  :red    => [255, 0  , 0    ],
  :green  => [0  , 255, 0    ],
  :blue   => [0  , 0  , 255  ],
  :yellow => [255, 255, 0    ],
  :aqua   => [0  , 255, 255  ],
  :indigo => [0x4B, 0x0, 0x82]
}

colours.each do |name, rgb|
  puts "#{name.to_s}  #{rgb}"
  led.on!(:rgb => rgb)
  sleep(2)
end

led.off!
