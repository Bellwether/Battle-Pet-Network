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
  
  def facebook_nested_url(url)
    return url.gsub(/facebook\//i,'') 
  end

  def render_tabs
    render(:partial => '/facebook/tabs')
  end
  
  def render_petless_callout
    render(:partial => '/facebook/petless_callout')
  end

  def render_breed_picker(form)
    render(:partial => '/facebook/breed_picker', :locals => {:form => form})
  end

  def breed_details_row(label,model,attribute)
    val = nil
    if model && model.respond_to?(attribute.to_sym) 
      val = model.attributes[attribute.to_sym]
    elsif model && model.favorite_action.respond_to?(attribute.to_sym) 
      val = model.favorite_action.send(attribute.to_sym)
    end 
    attribute = attribute.to_s.gsub(/_/,'-')
    "<tr><td>#{label}:</td><td><span id=\"breed-details-#{attribute.to_s}\">#{val}</span></td></tr>"
  end
    
  def fb_fan_button
   "<fb:fan profile_id=\"#{AppConfig.facebook.app_id}\" stream=\"0\" connections=\"0\" width=\"200\" height=\"64\" logobar=\"false\"></fb:fan>"
  end
  
  def cell_table(array,cols=3)
    render :text => "<table><tbody>"
    array.each_with_index do |row,idx|
  	  render :text => "<tr>" if idx % cols == 0
      yield row, idx
      render :text =>  "</tr>" if idx % cols == (cols - 1)
    end
    render :text => "</tbody></table>"
  end  
end