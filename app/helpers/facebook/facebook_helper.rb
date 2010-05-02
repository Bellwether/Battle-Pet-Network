module Facebook::FacebookHelper
  def facebook_stylesheet_link_tag(path)
    "<link type='text/css' media='screen' href='#{request.protocol}#{request.host_with_port}#{stylesheet_path(path)}?v=1.0' />"
  end

  def facebook_javascript_tag(path)
    "<script src='#{request.protocol}#{request.host_with_port}/javascripts/#{path}.js?v=1.0' type='text/javascript'></script>"
  end
  
  def facebook_image_tag(path)
    image_tag "#{request.protocol}#{request.host_with_port}/images/#{path}"
  end
  
  def facebook_link_to(text,url)
    link_to text, "#{url}"
  end

  def render_tabs
    render(:partial => '/facebook/tabs')
  end
  
  def fb_fan_button
   "<fb:fan profile_id=\"#{AppConfig.facebook.app_id}\" stream=\"0\" connections=\"0\" width=\"200\" height=\"64\" logobar=\"false\"></fb:fan>"
  end
end