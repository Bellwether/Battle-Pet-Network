require 'test_helper'
require 'flexmock/test_unit'

class TweetsToHtmlTest < ActiveSupport::TestCase
  def setup
    mock_tweets
  end
  
  def test_load_xml
    twitter = Twitter::TweetsToHtml.new
    assert_not_nil twitter.doc
  end
end