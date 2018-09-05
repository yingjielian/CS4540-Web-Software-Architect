# Assignment 1
# Name: Yingjie Lian
# Github username: yingjielian
#
# What it's for: In order to run this code, first download to your local disk. Then, open 
# ternimal and go to the directory of cs4540-fall-2018-assignment-1-yingjielian. Next, typing
# "ruby web_server_test.rb" to run the test, and it will print out the local server information
# to the console. 

# How to use it: Then, typing "ruby run_web_server.rb" to operate the code and start to listen the 
# local server. Finally, typing "localhost:1234" in the browser to see the result and it will work.
#
#
# How many hours did it take to finish this assignment: 8.8

require 'socket' # Provides TCPServer and TCPSocket classes

# Creates a class called "WebServer"
class WebServer
    
    # Creates a method called "initialize" to initialize a TCPServer object that will listen 
    # on localhost:1234 for incoming connections.
    def initialize(host='localhost', port=1234)
       @server = TCPServer.new(host, port)
    end
    
    # Creates a method called "listen" in order to call collect_request, create_response,
    # write_response
    def listen()
      # loop infinitely, processing one incoming connection at a time.    
      loop do
	@socket=@server.accept
        collect_request
        create_response
        write_response
      end
    end
    
    # Creates a method called "collect_request" in order to collect the request contents
    def collect_request()
        # Read the first line of the socket (the Request-Line) for 10 times
        @request_lines  = []
        10.times do
            @request_lines  << @socket.gets
        end
    end
    
    # Creates a method called "create_response" in order to create the response from the 
    # request_lines that we collect in collect_request
    def create_response()
        STDERR.puts "Contents of the request just received..."
        STDERR.puts @request_lines
        @response= "/200 OK/ You are using " + @request_lines[2].split[1]
    end
    
    # Creates a method called "create_response" in order to write the response to the local server
    # that will show the text in the broswer.
    def write_response()
	info='<!doctype html>
	      <html lang="zh-Hans">
	      <body bgcolor="#FF7F50" style=font-family:tahoma;color:#24c93a;font-size:28px;text-align:left;line-height:280px;>Homework1 Extra Part! 
            <h1>Thank you!</h1>
		<p id="p1">Goodbye!</p>
	      </body>
	      </html>'
        @socket.print "HTTP/1.1 200 OK\r\n" +
               "Content-Type: text/html; charset=utf-8\r\n" +
               "Content-Length: #{info.bytesize}\r\n" +
               "Connection: close\r\n"
	@socket.print "\r\n"
	@socket.print info
    end
end

#server1 = WebServer.new('localhost', 2344)
#server2 = WebServer.new('localhost', 2344)
#server2.number_of_servers => 2