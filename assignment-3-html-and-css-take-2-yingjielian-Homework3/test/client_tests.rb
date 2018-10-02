require 'net/http'
require_relative './test_helper'
require_relative '../ksl_watcher'


class WebServerTest < Minitest::Test
  include Minitest::Hooks
  include CssParser

  PORT = 2343
  URL = "localhost"

  def before_all
    super
    @ws_thread = Thread.new { WebServer.new(PORT).listen }
  end

  def after_all
    Thread.kill(@ws_thread) if @ws_thread
    super
  end
  
  def setup
  # before each test, pause for a second to give the
  # web server time to close the connection from the 
  # prior request
  sleep(1)
  end

  def test_index_html
    res = Net::HTTP.get(URL, '/index.html', PORT)
    res = res.split.join(' ')

    # requested content
    assert(res.include?('Welcome to the KSLWatcher!'))
    assert(res.include?('This service will keep an eye on the KSL Classifieds for you and alert you when a new listing of interest appears.'))
    assert(res.include?('Using this system means:'))
    assert(res.include?('no longer do you need to visit KSL regularly to check for that unopened BeeGees vinyl record you\'ve been pining after'))
    assert(res.include?('don\'t lose out to someone who\'s spending all their time scanning the KSL site while you do real work in the real world'))
    assert(res.include?('Sign up to be on our mailing list'))

    # requested button label
    button = res.match(/<a[^>]+>([^<]+)<\/a>/)
    button_label = button[1]

    # requested button target
    assert(button_label.downcase == 'register')
    assert(button[0].match(/href=["']([^"']+)/))

    # general HTML correctness
    assert(general_html_goodness(res))
  end

  def test_signup_content
    res = Net::HTTP.get(URL, '/signup.html', PORT)
    res = res.split.join(' ')
    assert(res.match(/<option value="Cars">Cars and Trucks<\/option>/))
    assert(res.match(/<option value="Appliances">Kitchen and Laundry Applicances<\/option>/))
    assert(res.match(/<option value="Tools">Tools, e.g. saws, anvils, hammers/))
    assert(res.match(/<option value="70's Music">Music of the 1970's<\/option>/))
    assert(res.match(/<option value="Other">Other Stuff<\/option>/))
    assert(res.match(/<select name="interests" size="1">/))

    # general HTML correctness
    assert(general_html_goodness(res))
  end

  def test_404_handling
    res = Net::HTTP.get(URL, '/bad_location.html', PORT)
    res = res.split.join(' ')
    assert(res.match(/Sorry, we couldn\'t find that page/))

    # general HTML correctness
    assert(general_html_goodness(res))
  end

  def test_css_file
    fname = 'ksl_watcher.css'

    assert(File.exist?(fname))
    
    parser = Parser.new
    parser.load_file!(fname)
    
    # nice-box class 
    assert(parser.find_by_selector('.nice-box').count == 1)

    # margins for nice-box = 20
    assert(parser.find_by_selector('.nice-box')[0].match(/margin:\s*(\d+)px/)[1] == '20')

    # montserrat font within body
    assert(parser.find_by_selector('body')[0].match(/font-family:\s*['"]Montserrat/))
  end



  private

  def general_html_goodness(html)
    # starts with a doctype html tag
    html.match(/^<!DOCTYPE html>/) and
    # has head opening and closing elements
    html.match(/<head>/) and html.match(/<\/head>/) and
    # has body opening and closing elements
    html.match(/<body>/) and html.match(/<\/body>/)
  end


end