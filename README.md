Frankenpins
===

A small library to make working with physical buttons on the Raspberry Pi easier.

Installation
---

Frankenpins currently relies on an unreleased version of the WiringPi2 library, so you need to add both dependencies to your Gemfile as follows:

    gem 'frankenpins', :github => 'radiodan/frankenpins'

The do a `sudo bundle install` to install them (see 'Sudo' below).

Sudo
---

You need to run your code as `sudo` so it can access the GPIO pins.

    $ sudo bundle exec bin/start

Pin numbering
---

Frankenpins uses the WiringPi convention for pin numbering. The wiring pi set has a [useful chart](http://wiringpi.com/).

![wiring pi pin numbering chart](http://wiringpi.com/wp-content/uploads/2013/03/gpio1.png)

Buttons
---

Frankenpins is event-based.

    require 'frankenpins'

    button = Frankenpins::Button.new(:pin => 0, :pull => :up)
    button.on :pressed do
      puts "Button pressed"
    end

    Frankenpins.wait

First we create a new button, telling the library that the button is on wiring pi pin number `0`, and that the pin's internal pull-up resistor should be used:

    button = Frankenpins::Button.new(:pin => 0, :pull => :up)

Then we register a block of code to be called whenever the button is pressed down:

    button.on :pressed do
      puts "Button pressed"
    end

The button events are:

 - `pressed` when the button is pushed down
 - `released` when the button is released
 - `changed` fires every time the button is pushed down or released

Finally, we tell Frankenpins to keep the program running until we quit it. Otherwise, it would exit and wouldn't be watching for our button presses.

    Frankenpins.wait

Pins
---

Frankenpins is based on the great [Pi Piper]() library, and uses a modified version of the Pin class which means you can register for events whenever a pin changes value. Check `examples/raw_pin.rb` for sample code.

Development
---

It's very early days for this library so any help is gratefully received.

