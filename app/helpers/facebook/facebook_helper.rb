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
  
  def facebook_link_to(text, url, options = {})
    link_to text, facebook_nested_url(url), options
  end
  
  def facebook_nested_url(url)
    return url.gsub(/facebook\/*/i,'') 
  end
  
  def avatar_image(model,size='small')
    path = model.class.name.downcase.pluralize
    if model.is_a?(Pet)
      breed_path = model.breed.name.downcase.pluralize
      path = "#{breed_path}/#{path}"
    elsif model.is_a?(Item)
      path = "#{path}/types" if size != 'medium' # medium show item detail, otherwise show type
    end
    filename = model.name.downcase.gsub(/\s/,'-')
    path = "#{path}/#{size}/#{filename}.png"
    return facebook_image_tag(path)
  end

  def render_tabs
    render(:partial => '/facebook/tabs')
  end
  
  def render_petless_callout
    render :partial => '/facebook/petless_callout'
  end

  def render_kibble_box
    render :partial => '/facebook/kibble_box'
  end

  def render_bio_box(pet)
    render :partial => '/facebook/bio_box', :locals => {:pet => pet}
  end

  def render_breed_picker(form)
    render :partial => '/facebook/breed_picker', :locals => {:form => form}
  end
  
  def render_breed_details(breed)
    render :partial => '/facebook/breed_details', :locals => {:breed => breed}
  end

  def render_item_picker(items,form=nil,attribute=nil)
    render :partial => '/facebook/item_picker', :locals => {:items => items, :form => form, :attribute => attribute}
  end

  def render_strategy_picker(form,strategy_name='attacker_strategy')
    render :partial => '/facebook/strategy_picker', :locals => {:form =>form,:strategy_name=>strategy_name}
  end

  def breed_details_row(label,model,attribute)
    val = nil
    if model && model.respond_to?(attribute.to_sym) 
      val = model.attributes[attribute.to_sym]
    elsif model && model.favorite_action.respond_to?(attribute.to_sym) 
      val = model.favorite_action.name
    end 
    attribute = attribute.to_s.gsub(/_/,'-')
    "<tr><td>#{label}:</td><td><span id=\"breed-details-#{attribute.to_s}\">#{val}</span></td></tr>"
  end

  def render_paypal_submit_tag
    image_submit_tag "https://www.paypal.com/en_US/i/btn/btn_xpressCheckout.gif", :class => "paypal-sm-button"
  end
  
  def experience_bar(level)
  end
  
  def percentage_bar(values,options={})
  end  
  
  def graph_bar(values,options={})
  end
    
  def fb_fan_button
    # should be replaced by 'like' button but doesn't work with new fb api
    # "<fb:fan profile_id=\"#{AppConfig.facebook.app_id}\" stream=\"0\" connections=\"0\" width=\"200\" height=\"64\" logobar=\"false\"></fb:fan>"
      return ""
  end
  
  def cell_table(array, cols=3, options = {}, &proc)
    if array.blank?
      concat("")
    end
    
    output = "<table class='#{(options[:class] || '')}'><tbody>"
    concat(output)
    
    array.each_with_index do |row,idx|
      concat("<tr>") if idx % cols == 0
      proc.call(row, idx)
      concat("</tr>") if idx % cols == (cols - 1) || idx == (array.size - 1)
    end
    concat("</tbody></table>")
  end  
  
  def show_for_pet(other_pet=nil)
  	yield if block_given? && has_pet? && (other_pet && (other_pet != current_user_pet ))
  end
end