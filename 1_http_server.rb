# Run this file with:
# ruby 1_http_server.rb

# This is a complete implementation of
# a static web server.

# Adapted from:
# https://github.com/elm-city-craftworks/practicing-ruby-examples/tree/master/v7/002

require 'socket'
require 'uri'

# Files will be served from this directory
WEB_ROOT = 'website/'

# Map file extensions to their HTTP content type
CONTENT_TYPE_MAPPING = {
  'html' => 'text/html',
  'txt' => 'text/plain',
  'png' => 'image/png',
  'jpg' => 'image/jpeg'
}

# Treat as binary data if content type cannot be found
DEFAULT_CONTENT_TYPE = 'application/octet-stream'

# This helper function parses the extension of the
# requested file and then looks up its content type.
def content_type(path)
  ext = File.extname(path).split(".").last
  CONTENT_TYPE_MAPPING.fetch(ext, DEFAULT_CONTENT_TYPE)
end

# This helper function parses the Request-Line and
# generates a path to a file on the server.
def requested_file(request_line)
  request_uri  = request_line.split(" ")[1]
  path = URI.unescape(URI(request_uri).path)
  File.join(WEB_ROOT, path)
end

server = TCPServer.new('localhost', 2345)

puts "Server listening on port 2345."
puts "Press Ctrl-C to exit."

loop do
  socket       = server.accept
  request_line = socket.gets

  puts "\nStarted #{request_line}"

  path = requested_file(request_line)
  path = File.join(path, 'index.html') if File.directory?(path)

  puts "  Will render file #{path}"

  # Make sure the file exists and is not a directory
  # before attempting to open it.
  if File.exist?(path) && !File.directory?(path)
    File.open(path, "rb") do |file|
      socket.print "HTTP/1.1 200 OK\r\n" +
                   "Content-Type: #{content_type(file)}\r\n" +
                   "Content-Length: #{file.size}\r\n" +
                   "Connection: close\r\n"

      socket.print "\r\n"

      # write the contents of the file to the socket
      IO.copy_stream(file, socket)
      puts "Completed 200"
    end
  else
    message = "File not found\n"

    # respond with a 404 error code to indicate the file does not exist
    socket.print "HTTP/1.1 404 Not Found\r\n" +
                 "Content-Type: text/plain\r\n" +
                 "Content-Length: #{message.size}\r\n" +
                 "Connection: close\r\n"

    socket.print "\r\n"

    socket.print message
    puts "Completed 404"
  end

  socket.close
end
