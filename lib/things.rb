require 'wiringpi'
require_relative './pin'

module Things
  extend self
  def watch(options={}, &block)
    Thread.new do 
      pin = Pin.new(options)
      loop do
        pin.wait_for_change
        block.call(pin)
      end
    end.abort_on_exception = true
  end

  #Prevents the main thread from exiting. Required when using PiPiper.watch
  def wait
    loop do sleep 1 end
  end

end  
