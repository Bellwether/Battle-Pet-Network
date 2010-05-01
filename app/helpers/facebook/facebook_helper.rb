module Facebook::FacebookHelper
  def facebook_stylesheet_link_tag(path)
    "<link type='text/css' media='screen' href='#{request.protocol}#{host_with_port}#{stylesheet_path(path)}?v=1.0' />"
  end

  def facebook_javascript_tag(path)
    "<script src='#{request.protocol}#{host_with_port}/javascripts/#{path}.js?v=1.0' type='text/javascript'></script>"
  end
end