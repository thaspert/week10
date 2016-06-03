# Run this file with:
# ruby 0_http_server.rb

require 'socket'

server = TCPServer.new('localhost', 2345)
puts "Server listening on port 2345."
puts "Press Ctrl-C to exit."

loop do
  socket = server.accept

  # Get the next incoming request
  request_line = socket.gets.chomp
  puts "\nStarted #{request_line}"
  while (header = socket.gets.chomp).length > 0
    puts "  #{header}"
  end

  # Generate an HTTP response
  socket.puts "HTTP/1.1 200 OK"
  socket.puts "Content-Type: text/html"
  socket.puts "Content-Length: 12"
  socket.puts "Connection: close"
  socket.puts
  socket.puts "Hello World!"

  puts "Completed 200"

  socket.close
end
