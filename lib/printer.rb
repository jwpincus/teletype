require_relative './print_helper'

class Typer

  def initialize
    @gpio = RPi::GPIO
    @gpio.set_numbering(:bcm)
    @matrix = {
      
    }
    @matrix.each {|k,v| setup_gpio(k)}    
  end
  
  def send_char(signal_pin, trigger_pin)
    while true
      if @gpio.low? signal_pin
        @gpio.set_low trigger_pin
        sleep(0.028)
        @gpio.set_high
        break
      end
    end
    sleep(.5)
  end
  
  def type_char(char)
    signal_pin = @matrix[char][0]
    trigger_pin = @matrix[char][1]
    send_char(signal_pin, trigger_pin)
  end
  
  def type_string(string)
    column = 0
    string.split('').each do |char|
      if column < 80 && char != ' '
        type_char(char)
      else
        type_char("return")
        column = 0
      end
    end
  end
  
  def setup_gpio(char)
    @gpio.setup(@matrix[char][0], :input, pull: :up)
    @gpio.setup(@matrix[char][1], :output, initialize: :high)
  end
    
end