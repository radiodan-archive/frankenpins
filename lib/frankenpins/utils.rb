module Frankenpins
  module Utils
    #Prevents the main thread from exiting. Required when using PiPiper.watch
    def wait
      loop do sleep 1 end
    end

    def watch(&block)
      Thread.new do
        loop do
          wait_for_change
          block.call(self)
        end
      end.abort_on_exception = true
    end
  end
end