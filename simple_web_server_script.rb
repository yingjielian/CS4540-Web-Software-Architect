# Borrowed from:  https://practicingruby.com/articles/implementing-an-http-file-server
#
#  This is some sample code that you'll need to refactor into a class
#  definition.  

# require 'socket' # Provides TCPServer and TCPSocket classes

# Initialize a TCPServer object that will listen
# on localhost:2345 for incoming connections.
# server = TCPServer.new('localhost', 2345)

# loop infinitely, processing one incoming
# connection at a time.
# loop do

  # Wait until a client connects, then return a TCPSocket
  # that can be used in a similar fashion to other Ruby
  # I/O objects. (In fact, TCPSocket is a subclass of IO.)
#  socket = server.accept

  # Read the first line of the request (the Request-Line)
 # lines = []
#  10.times do
 #   lines << socket.gets
#  end 
  
#  request = socket.gets
  #line_2 = socket.gets
  #line_3 = socket.gets

  # Log the request to the console for debugging
  #STDERR.puts request
  #STDERR.puts line_2
  #STDERR.puts line_3

#STDERR.puts "----------------"
#lines.each do |single_line, index|
 # STDERR.puts "#{index+1}. #{single_line}"
  #STDERR.puts index + '. ' + single_line
#end

#STDERR.puts lines "-----------------"

  # extract the line of headers with the user agent
 # user_agent_line = lines[2]
  # tokenize it and extract the user agent string to return
  #user_agent_str = user_agent_line.split[1]
  
  #response = "You are using #{user_agent_str}\r\n"
  #STDERR.puts "sending back this: #{response}"
  
  #response = "Hello World!\n"

  # We need to include the Content-Type and Content-Length headers
  # to let the client know the size and type of data
  # contained in the response. Note that HTTP is whitespace
  # sensitive, and expects each header line to end with CRLF (i.e. "\r\n")
  #socket.print "HTTP/1.1 200 OK\r\n" +
   #            "Content-Type: text/plain\r\n" +
    #           "Content-Length: #{response.bytesize}\r\n" +
     #          "Connection: close\r\n"

  # Print a blank line to separate the header from the response body,
  # as required by the protocol.
  #socket.print "\r\n"

  # Print the actual response body, which is just "Hello World!\n"
  #socket.print response

  # Close the socket, terminating the connection
  #socket.close
#end
# Borrowed from:  https://practicingruby.com/articles/implementing-an-http-file-server
#
#  This is some sample code that you'll need to refactor into a class
#  definition.  

require 'socket' # Provides TCPServer and TCPSocket classes

# Initialize a TCPServer object that will listen
# on localhost:2345 for incoming connections.
server = TCPServer.new('localhost', 2345)

# loop infinitely, processing one incoming
# connection at a time.
loop do

  # Wait until a client connects, then return a TCPSocket
  # that can be used in a similar fashion to other Ruby
  # I/O objects. (In fact, TCPSocket is a subclass of IO.)
  socket = server.accept

  # Read the first line of the request (the Request-Line)
  request = socket.gets
  line_2 = socket.gets
  line_3 = socket.gets

  # Log the request to the console for debugging
  STDERR.puts request
  STDERR.puts line_2
  STDERR.puts line_3

  response = "Hello World!\n"

  # We need to include the Content-Type and Content-Length headers
  # to let the client know the size and type of data
  # contained in the response. Note that HTTP is whitespace
  # sensitive, and expects each header line to end with CRLF (i.e. "\r\n")
  socket.print "HTTP/1.1 200 OK\r\n" +
               "Content-Type: text/plain\r\n" +
               "Content-Length: #{response.bytesize}\r\n" +
               "Connection: close\r\n"

  # Print a blank line to separate the header from the response body,
  # as required by the protocol.
  socket.print "\r\n"

  # Print the actual response body, which is just "Hello World!\n"
  socket.print response

  # Close the socket, terminating the connection
  socket.close
end