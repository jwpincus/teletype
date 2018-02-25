require_relative './print_helper'

class Typer

  def initialize
    @gpio = RPi::GPIO
    @gpio.set_numbering(:bcm)
    @matrix = {
      ',' => [26, 21], '/' => [26, 20], '1' => [26, 16], '3' => [26, 12], '7' => [26, 7], '5' => [26, 8], '-' => [26, 25], '9' => [26, 24],
      '.' => [19, 21], '+' => [19, 20], '2' => [19, 16], '4' => [19, 12], '8' => [19, 7], '6' => [19, 8], '=' => [19, 25], '0' => [19, 24],
      '1/2' => [13, 21], 'q' => [13, 20], 'e' => [13, 16], 't' => [13, 12], 'o' => [13, 7], 'u' => [13, 8], 'n' => [13, 25], 'v' => [13, 24],
      ';' => [6, 21], 'z' => [6, 20], 'f' => [6, 16], 'h' => [6, 12], 's' => [6, 7], 'k' => [6, 8], 'x' => [6, 25], 'c' => [6, 24],
      ']' => [5, 21], 'w' => [5, 20], 'r' => [5, 15], 'y' => [5, 12], 'p' => [5, 7], 'i' => [5, 8], 'm' => [5, 25], 'b' => [5, 24],
      "''" => [11, 21], 'a' => [11, 20], 'g' => [11, 111], 'j' => [11, 12], 'd' => [11, 7], 'l' => [11, 8],
      ' ' => [9, 21], 'return' => [9, 20], 'newline' => [9, 19], 'backspace' => [9, 8], 'shift' => [10, 21]
        }
    @matrix.each {|char,v| setup_gpio(k)}    
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
    sleep(0.5)
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
        type_char(char.downcase)
        column += 1
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