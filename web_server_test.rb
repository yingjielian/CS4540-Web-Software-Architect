require_relative './web_server'
require 'minitest/autorun'


class WebServerTest < Minitest::Test

  REQUEST_HEADERS = <<-STRING_END
    Host: localhost:2345
    User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:61.0) Gecko/20100101 Firefox/61.0
    Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
    Accept-Language: en-US,en;q=0.5
    Accept-Encoding: gzip, deflate
    DNT: 1
    Connection: keep-alive
    Upgrade-Insecure-Requests: 1
  STRING_END

  URL_AND_PROTOCOL = "/favicon.ico HTTP/1.1"
  
  GET_REQUEST = ["GET #{URL_AND_PROTOCOL}"] + REQUEST_HEADERS.split("\n")
  PUT_REQUEST = ["PUT #{URL_AND_PROTOCOL}"] + REQUEST_HEADERS.split("\n")
  POST_REQUEST = ["POST #{URL_AND_PROTOCOL}"] + REQUEST_HEADERS.split("\n")
  DELETE_REQUEST = ["DELETE #{URL_AND_PROTOCOL}"] + REQUEST_HEADERS.split("\n")

  def test_able_to_create_webserver_object_with_specified_port
    ws = WebServer.new(2344)
    assert(ws)
  end

  def test_able_to_create_webserver_object_with_no_specified_port
    ws = WebServer.new
    assert(ws)
  end

  def test_listen_exists
    ws = WebServer.new(2346)
    assert(ws.methods.include?(:listen))
  end

  def test_collect_request_exists
    ws = WebServer.new(2347)
    assert(ws.methods.include?(:collect_request))
  end

  def test_create_response_exists
    ws = WebServer.new(2348)
    assert(ws.methods.include?(:create_response))
  end

  def test_write_response_exists
    ws = WebServer.new(2349)
    assert(ws.methods.include?(:write_response))
  end

   def test_response_with_get_is_handled
    ws = WebServer.new(2350)
    
    # this is some metaprogramming -- it adds a new function to the
    # class during runtime.
    def ws.set_request_lines(some_lines_as_array)
      @request_lines = some_lines_as_array
    end
    def ws.get_response
      return @response
    end

    ws.set_request_lines(GET_REQUEST)
    ws.create_response
    response = ws.get_response

    assert(response.match(/200 OK/))
    assert(response.match(/You are using Mozilla\/5.0/))
  end
end