module Facebook::ItemsHelper
  def item_store_table(item_type, alt)
    avatar_path = "items/types/medium/#{item_type.downcase}.png"
    return "<table class='item-store'>" <<
      "<tr><td rowspan='3'>#{facebook_image_tag(avatar_path, :title => alt)}</td>" <<
      "<td><strong>#{item_type} Store</strong></td></tr>" <<
      "<tr><td>#{pluralize(Item.type_is(item_type).in_stock.count, 'types')}<br />#{Item.type_is(item_type).in_stock.sum(:stock)} in stock</td></tr>" <<
      "<tr><td><span class='shopping-button'>#{facebook_link_to('Go Shopping',store_facebook_item_path(item_type))}</span></td></tr>" <<
      "</table>"
  end
end