# CS4540
# Assignment 3
#
# Zaphod Beeblebrox
# Github username: presidentoftheuniverse
# 
# The class defined here stands up a server that provides the
# backend for a simple web site.
#
#
# To use:
#   my_server = WebServer.new
#   my_server.listen
#
# To stop the server, kill process from the command line with Control-C
#
# How many hours did it take to finish this assignment:  0.45



# Pull in a Ruby library that gives us tcp handling
# Adds TCPServer and TCPSocket as classes.
require 'socket'
# Add ability to parse query parameters (the data that are included in
# a url to pass info to the server)
require 'cgi'

class WebServer

  # constants in Ruby are in all caps
  # this will be the port that the server listens on
  PORT_NUMBER = 2345

  # initialize is the Ruby class constructor name
  def initialize(port=PORT_NUMBER)
    # moving the TCPServer spin up to listen 
    @port = port
    self
  end

  # listen is a method that does just that...listens on the
  # port established in the constructor for incoming tcp messages
  def listen
    @server = TCPServer.new('localhost', @port)
    # so, now we have a tcp server object stuffed in @server
    # let the user know the system is running
    puts "Listening on port #{@port}..."

    # we need an infinite loop here...there are tons of ways to
    # do that in Ruby.  Here's one:
    while true do
      collect_request
      route_request
      create_response_string
      write_response
    end
  end

  # creates a request object, a hash that represents the
  # components of an http request.  specifically:
  #    type - GET, PUT, PUSH, DELETE, etc.
  #    path - the requested path in the website
  #    headers - a hash of header fields and their values
  #
  # Parameters:  none
  # Returns:  nothing
  # Assumptions:  @socket is populated
  # Side effects:  creates/populates @request
  def collect_request
    # instantiate an empty hash
    @request = {}

    @socket = @server.accept  # blocks here
    # collect request lines until we hit a blank line
    temp_request_lines = []
    loop do
      temp_line = @socket.gets
      if temp_line and temp_line.strip == ''
        break
      else
        temp_request_lines << temp_line
      end
    end

    # parse the request
    @request[:type] = extract_from(temp_request_lines, :type)
    @request[:path] = extract_from(temp_request_lines, :path)
    @request[:headers] = extract_from(temp_request_lines, :headers)
  end


  # processes a request by:
  #   1.  checking the path requested...is it a destination
  #       we know about and can handle?
  #   2.  dispatching to a method for that path
  #   3.  receiving html from that method
  #   4.  saving the html to an instance var
  #
  # Parameters:  none (because @request is being used)
  # Returns:  nothing
  # Assumptions:  @request is populated
  # Side effects:  creates/populates @response (a hash)
  def route_request
    begin    
      # route the request
      case @request[:path]
      
      when '/', '/index.html', 'index'
        @response = handle_index
      
      when /^\/signup/
        @response = handle_signup_get

      when /ksl_watcher.css/
        @response = handle_css
      else
        @response = handle_file_not_found
      end
    rescue StandardError => e
      # something happened when trying to find
      # the targeted files (which will happen when
      # you don't have them all defined).  in that
      # case, default to a basic error page.
      @response = handle_other_error(e.message, e.backtrace.join("\n"))
    end
  end

  def create_response_string
    # the @response object is a hash so we need to deference
    # its contents to produce a string value suitable for the socket

    # At this point, the @response object looks like this:
    #  @response = {
    #    :status => <a status code>
    #    :reason => <a reason string>
    #    :headers => <a hash of headers>
    #    :body => <the html for the page>
    #  }

    # I'm using the lecture notes describing an HTTP Response...
    # the header line
    status_line = "HTTP/1.1 #{@response[:status]} #{@response[:reason]}\r\n"

    # the header line
    # we need to a little work here to translate the headers hash into
    # a more json-like structure
    header_line = reformat_hash_to_string(@response[:headers]) + "\r\n\r\n"
    
    # the body line
    body_lines  = @response[:body] + "\r\n"

    # combine them all to create the response as one big string
    @response_as_string = status_line + header_line + body_lines
  end


  # writes the response to the client on the socket object
  #
  # Parameters:  none
  # Returns:  nothing
  # Assumptions:  @response_string is populated
  # Side effects:  writes to the socket  
  def write_response
    @socket.print @response_as_string

    # close the socket
    @socket.close
  end

  private

  # Parses the raw request lines to extract the type, path, or headers.
  #
  # Parameters:  raw_request_lines (an array of strings)
  #              target:  one of :type, :path, or :headers
  # Returns:  the requested target
  #   for :type or :path, that's a single string
  #   for :headers, that's an array of strings
  # Assumptions:  only the five most common request types handled
  # Side effects:  none  
  def extract_from(raw_request_lines, target)
    case target 
    when :type
      md = raw_request_lines.first.strip.match(/^(GET|PUT|PATCH|POST|DELETE) /)
      return md[1] if md and md[1]
      raise "Unable to find the request type in: #{raw_request_lines.first}"
    when :path
      md = raw_request_lines.first.strip.match(/^(GET|PUT|PATCH|POST|DELETE) (\S+) HTTP/)
      return md[2] if md and md[1]
      raise "Unable to find the path in: #{raw_request_lines.first}"
    when :headers
      return raw_request_lines.drop(1)
    else
      raise ArgumentError, "extract_from unable to handle: #{target}"
    end
  end

  # converts a hash's keys and values to a string in which 
  # 1. the keys and values are delimited by a colon, 
  # 2. the key/value pairs are delimited by a CRLF combo. 
  def reformat_hash_to_string(h)
    h.to_a.map { |x| "#{x[0]}: #{x[1]}" }.join("\r\n")
  end

  def handle_index
    get_html_file('pages/index.html')
  end

  def handle_signup_get
    get_html_file('pages/signup.html')
  end

  def handle_css
    get_html_file('ksl_watcher.css', 'text/css')
  end

  def handle_file_not_found
    get_html_file('pages/404.html')
  end

  def handle_other_error(msg = 'bad request - unknown error', body = '')
    { status: 400, reason: msg, body: body }
  end

  def handle_missing_values
    get_html_file('pages/missing_values.html')
  end

  # generates the start of a response as a hash of status, headers, and body
  # given a file of html (or css) and a content_type that defaults to text/html.
  def get_html_file(fname, content_type = 'text/html')
    html = File.open(fname).readlines
    { status: 200, 
      headers: { 'Content-Type' => content_type },
      body: html.join("\n") }
  end
end


# Code to allow this file to operate either as a required library or
# to be called as a script. 
if __FILE__ == $0
  if ARGV.count == 1
    ws = WebServer.new(ARGV[0])
  else
    ws = WebServer.new
  end
  ws.listen
end
