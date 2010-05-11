module Facebook::ItemsHelper
  def item_store_table(item_type, description)
    "<table class='item-store'>" <<
      "<tr><td rowspan='3'><div class='item-type-#{item_type.downcase.gsub(/\s/,'-')}-mid left'></div></td>" <<
      "<td><strong>#{item_type<<' Store'}</strong></td></tr>" <<
      "<tr><td>#{Item.type_is(item_type).in_stock.count} types, #{Item.type_is(item_type).in_stock.sum(:stock)} in stock</td></tr>" <<
      "<tr><td><span class='shopping-button'>#{facebook_link_to('Go Shopping',store_facebook_item_path(item_type))}</span></td></tr>" <<
      "<tr><td colspan='2'>#{description}</td></tr>" <<
      "</table>"
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