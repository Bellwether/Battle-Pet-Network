require 'open-uri'
require 'hpricot'

class Twitter::TweetsToHtml
  require 'action_view/test_case'

  TWITTER_USERNAME = "battlepet"
  TWEETS_ENDPOINT = "http://api.twitter.com/1/statuses/user_timeline.xml?screen_name=#{TWITTER_USERNAME}"
  URL_PREFIX = "http://twitter.com/#{TWITTER_USERNAME}/statuses/"

  attr_accessor :doc
  
  def initialize
    @doc = load_xml(TWEETS_ENDPOINT)
  end  
  
  def to_html
    html = ""
    (@doc/'status').each do |st|
      user = (st/'user name').inner_html
      text = (st/'text').inner_html
      tid = (st/'id').inner_html
      text = parse_tweet(text)
      
      html << "<li>#{text} <em><a href=\"#{URL_PREFIX}#{tid}\">#</a></em></li>"
    end
    return "<ul id='tweets'>#{html}</ul>"
  end
  
  def load_xml(path)
    puts "BAAAD"
    return Hpricot( open( TWEETS_ENDPOINT ) ) 
  end  
  
  def parse_tweet(text)
    URI.extract(text, %w[ http https ftp ]).each do |url|
      text.gsub!(url, "<a href=\"#{url}\">#{url}</a>")
    end
    text = linkup_mentions_and_hashtags(text)
    return text
  end  
end