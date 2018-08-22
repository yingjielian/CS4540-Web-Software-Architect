require_relative './web_server'
require 'minitest/autorun'


class WebServerTest < Minitest::Test

  def test_able_to_create_webserver_object
    ws = WebServer.new(2345)
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



end