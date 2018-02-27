require_relative './print_helper'

class Fetcher
  
  def initialize
    @api_url = 'https://messages-to-cayley.herokuapp.com/api/messages'
  end
  
  def fetch_queue
    response = HTTParty.get(@api_url)
    @messages = JSON.parse(response.body)
  end
  
  def type_all_messages
    fetch_queue
    @messages.each {|message| type(message)}
  end
  
  def type(message)
    @typewriter ||= Typer.new
    @typewriter.type_string(message['author'])
    @typewriter.newline(2)
    @typewriter.type_string(message['title'])
    @typewriter.newline(2)
    @typewriter.type_string(message['body'])
    @typewriter.newline(2)
    @typewriter.type_string(message['signature'])
    @typewriter.newline(2)
    @typewriter.type_string(message['postscript'])
  end
  
end

