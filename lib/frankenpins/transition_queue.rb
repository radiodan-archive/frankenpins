module Frankenpins
  # A transition queue
  # Items added to the queue are
  # executed in order
  class TransitionQueue
    def initialize
      @queue = Queue.new
      @debug = false
    end

    def push(transition)
      puts "E: #{transition.type} #{transition}" if @debug
      @queue.push(transition)
    end

    def start!
      Thread.new do
        loop do
          transition = @queue.pop
          puts "D: #{transition.type} #{transition}" if @debug
          transition.perform!
        end
      end
    end
  end
end
