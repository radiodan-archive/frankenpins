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

Examples
---

There is demo code in the `examples` folder showing how to use of each of the components.

Buttons
---

Frankenpins is event-based.

    require 'frankenpins'

    button = Frankenpins::Button.new(:pin => 0, :pull => :up)
    button.when :pressed do
      puts "Button pressed"
    end

    Frankenpins.wait

First we create a new button, telling the library that the button is on wiring pi pin number `0`, and that the pin's internal pull-up resistor should be used:

    button = Frankenpins::Button.new(:pin => 0, :pull => :up)

Then we register a block of code to be called whenever the button is pressed down:

    button.when :pressed do
      puts "Button pressed"
    end

The button events are:

 - `pressed` when the button is pushed down
 - `released` when the button is released
 - `changed` fires every time the button is pushed down or released

Finally, we tell Frankenpins to keep the program running until we quit it. Otherwise, it would exit and wouldn't be watching for our button presses.

    Frankenpins.wait


LEDs
---

You can control a Light Emitting Diode (LED) connected to WiringPi pin 5 as follows:

    require 'frankenpins'

    led = Frankenpins::LED.new(:pin => 5)
    led.on
    sleep(3)
    led.off

### Brightness

You can specify the brightness of the LED. Brightness can be between `0` (off) and `100` (on) and must be an integer.

    require 'frankenpins'

    led = Frankenpins::LED.new(:pin => 5)
    led.on
    led.brightness(50) # 50% brightness

### Transitions

Turning an LED on and off is good, but Frankenpins can do better. It allows you to fade the LED over a set duration. `on`, `off` and `brightness` all take a `:duration` option that specifies the number of seconds to fade over. This example fades the LED on over 1 second, fades to 50% brightness over 1 second and then off over 2 seconds.

    require 'frankenpins'

    led = Frankenpins::LED.new(:pin => 5)
    led.on(:duration => 1)
    led.brightness(50, :duration => 1)
    led.off(:duration => 2)



You can set a `default_transition` in seconds which will apply to all calls. This example makes the LED to fade on over 2 seconds and then off over 2 seconds:

    require 'frankenpins'

    led = Frankenpins::LED.new(:pin => 5)
    led.default_duration = 2
    led.on
    led.off


### A note about transitions

The transitions are all queued up but don't stop your code from running. So, if you have:

    led.on(:duration => 10)
    led.off(:duration => 1)

Your code won't stop for 11 seconds until the transitions have finished, the transitions will happen in the background. This means your main programme may finish before the transitions do, to avoid that use `Frankenpins.wait` to keep your main code running:

    led.on(:duration => 10)
    led.off(:duration => 1)
    Frankenpins.wait

RGB LEDs
---

These work in the same way as LEDs above, except that the LED has 4 legs. A common ground and 1 for each colour.

Connect each leg to a pin and tell Frankenpins about it. You can then use them in much the same way as a normal LED, except instead of specifying on overall brightness, you specify a colour to change the LED to.

    require 'frankenpins'

    led = Frankenpins::RGBLED.new(:pins => { :green => 5, :red => 4, :blue => 1 })
    led.on
    led.rgb([255, 0, 0])

`rgb([r, g, b])` requires a value for red, green, blue from 0-255 where 0 is off and 255 is full brightness.

`percentage([r, g, b])` requires a value from 0-100 for each colour where 0 if off and 100 if full brightness.

RGB LEDs also support transitions too, so the following works. This example will make the RGB transition to purple over 2 seconds and then turn off over 1 second.

    require 'frankenpins'

    led = Frankenpins::RGBLED.new(:pins => { :green => 5, :red => 4, :blue => 1 })
    led.default_duration = 2
    led.on
    led.rgb([0, 255, 255])
    led.off(:duration => 1)


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
