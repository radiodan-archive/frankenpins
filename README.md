Frankenpins
===

A small library to make working with physical buttons on the Raspberry Pi easier.

Installation
---

To use Frankenpins using Rubygems:

    gem install frankenpins

If you're using Bundler, put the following in your `Gemfile`:

    gem 'frankenpins'

Then run `sudo bundle install` to install the gem (see 'Sudo' below).

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

Frankenpins Pin event implementation is based on the great [Pi Piper](https://github.com/jwhitehorn/pi_piper) library, and uses a modified version of the Pin class which means you can register for events whenever a pin changes value. Check `examples/raw_pin.rb` for sample code.

Versioning
---

We use [Semantic Versioning](http://semver.org/) and as this is pre-1.0.0 software, anything may change at any time.

Development
---

It's very early days for this library so any help is gratefully received.

Raise an issue in Github to discuss what you'd like to see included.
