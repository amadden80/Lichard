require 'socket'


# Server
class Kathew
  def initialize(port)
    @server = TCPServer.new 2000
  end

  def run
    loop do
      Thread.start(server.accept) do |client|
        client.puts "Hello !"
        client.puts "Time is #{Time.now}"
        client.close
      end
    end
  end

  def respond

  end

end
