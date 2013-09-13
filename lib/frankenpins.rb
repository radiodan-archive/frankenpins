require 'bundler/setup'
require_relative 'frankenpins/utils'
require_relative 'frankenpins/wiring_pi_singleton'
require_relative 'frankenpins/pin'

module Frankenpins
  include Utils
  module_function :wait
end  
