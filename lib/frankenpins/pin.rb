# A modified version of PiPiper's pin class
#   https://github.com/jwhitehorn/pi_piper/blob/master/lib/pi_piper/pin.rb
#
require_relative './utils'
require_relative './wiring_pi_singleton'

module Frankenpins
  # Represents a GPIO pin on the Raspberry Pi
  class Pin
    include Utils
    
    INPUT = 0
    PUD_OFF = 0
    PUD_DOWN = 1
    PUD_UP = 2

    attr_reader :pin, :last_value, :value, :direction, :invert
   
    def wiring_to_gpio(pin)
      gpio = pin
      gpio = 17 if pin == 0
      gpio
    end 

   def gpio_to_wiring(pin)
      wiring = pin
      wiring = 0 if pin == 17
      wiring
   end
    
    #Initializes a new GPIO pin.
    #
    # @param [Hash] options A hash of options
    # @option options [Fixnum] :pin The pin number to initialize. Required.
    # @option options [Symbol] :direction The direction of communication, either :in or :out. Defaults to :in.
    # @option options [Boolean] :invert Indicates if the value read from the physical pin should be inverted. Defaults to false.
    # @option options [Symbol] :trigger Indicates when the wait_for_change method will detect a change, either :rising, :falling, or :both edge triggers. Defaults to :both.
    # @option options [Symbol] :pull Use an internal pull-up/down resistor, either :up, :down, :none
    def initialize(options)
      options = {:direction => :in, :invert => false, :trigger => :both, :pull => :none}.merge options
      @pin = wiring_to_gpio options[:pin]
      @direction = options[:direction]
      @invert = options[:invert]
      @trigger = options[:trigger]
      @pull = options[:pull]
      @io = WiringPiSingleton.gpio_instance

      raise "Invalid direction. Options are :in or :out" unless [:in, :out].include? @direction
      raise "Invalid trigger. Options are :rising, :falling, or :both" unless [:rising, :falling, :both].include? @trigger
     
      File.open("/sys/class/gpio/export", "w") { |f| f.write("#{@pin}") }
      File.open(direction_file, "w") { |f| f.write(@direction == :out ? "out" : "in") }

      if @pull == :up || @pull == :down
        #pull_dir = @pull == :up ? "up" : "down"
	#`gpio mode #{gpio_to_wiring(@pin)} #{pull_dir}`

        wiring_pin = gpio_to_wiring(@pin)
        #@io.pin_mode(wiring_pin,INPUT)
        direction = PUD_UP   if @pull == :up
        direction = PUD_DOWN if @pull == :down
        puts "direction #{direction}"
        @io.pullUpDnControl(wiring_pin, direction)
      end

      read 
    end
    
    # If the pin has been initialized for output this method will set the logic level high.
    def on
      File.open(value_file, 'w') {|f| f.write("1") } if direction == :out
    end
    
    # Tests if the logic level is high.
    def on?
      not off?
    end
    
    # If the pin has been initialized for output this method will set the logic level low.
    def off
      File.open(value_file, 'w') {|f| f.write("0") } if direction == :out
    end
    
    # Tests if the logic level is low.
    def off?
      value == 0
    end

    # If the pin has been initialized for output this method will either raise or lower the logic level depending on `new_value`.
    # @param [Object] new_value If false or 0 the pin will be set to off, otherwise on.
    def update_value(new_value)
      !new_value || new_value == 0 ? off : on
    end
    
    # Tests if the logic level has changed since the pin was last read.
    def changed?
      last_value != value
    end

    # blocks until a logic level change occurs. The initializer option `:trigger` modifies what edge this method will release on.
    def wait_for_change
      fd = File.open(value_file, "r")
      File.open(edge_file, "w") { |f| f.write("both") }
      loop do
        fd.read
        IO.select(nil, nil, [fd], nil)
        read 
        if changed?
          next if @trigger == :rising and value == 0
          next if @trigger == :falling and value == 1
          break
        end
      end
    end

    # Reads the current value from the pin. Without calling this method first, `value`, `last_value` and `changed?` will not be updated. 
    # In short, you must call this method if you are curious about the current state of the pin.
    def read 
      @last_value = @value
      val = File.read(value_file).to_i
      @value = invert ? (val ^ 1) : val
    end
    
    private
    def value_file
      "/sys/class/gpio/gpio#{pin}/value"
    end

    def edge_file
      "/sys/class/gpio/gpio#{pin}/edge"
    end

    def direction_file
      "/sys/class/gpio/gpio#{pin}/direction"
    end
  
  end
end
