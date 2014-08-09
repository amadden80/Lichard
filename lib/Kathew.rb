require 'pry'
require 'socket'

# Server
class Kathew
  def initialize(port)
    @port = port
    @server = TCPServer.new(port)
  end

  def run()
    puts "                                listening on port #{ @port }..."
    loop do
      Thread.start(@server.accept) do |client|
        puts "                                +++  #{Time.now} +++"
        puts " "

        # request_string = client.readpartial(1024*5)
        # request = Request.new(request_string)

        # pp request

        client.puts 'Hey matt'
        client.close

        puts " "
        puts "                                ---  #{Time.now}  ---"
      end
    end
  end

end


class Request
  attr_reader :verb, :path, :host, :accept, :cookies, :content_length, :content
  def initialize(request_string)
    @verb = request_string.scan(/\A\w+/).flatten.first.downcase.to_sym
    @path = request_string.scan(/\A\w+ ([\/\w\d]+)/).flatten.first.strip
    @host = request_string.scan(/Host: (.*)$/).flatten.first.strip
    @accept = request_string.scan(/Accept: (.*)$/).flatten.first.strip
    @cookies = parse_cookies(request_string.scan(/Cookie: (.*)$/).flatten.first.strip)
    @content_length = request_string.scan(/Content-Length: (\d+)/).flatten.first.strip
    if @content_length
      @content = request_string[(-1- @content_length.to_i)..(-1)].strip
    end
  end
  def parse_cookies(cookies_string)
    @cookies = {}
    cookie_pairs = cookies_string.split('; ').map do |cookie|
      cookie.split('=')
    end
    cookie_pairs.each do |cookie|
      @cookies[cookie[0].to_sym] = cookie[1]
    end
    @cookies
  end
  # def to_s
  #   "#{ @verb }: #{ @host }#{ @path }"
  # end
end

server = Kathew.new(2345)
server.run
