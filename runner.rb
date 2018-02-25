require './lib/printer'

printer = Printer.new

while true
  printer.type_string(gets.chomp)
  
end