module Facebook::BelongingsHelper
  def link_to_belonging(belonging)
    case belonging.item.item_type
      when 'Food'
        if belonging.status == "holding"
        else
        end
      when 'Toy'
        if belonging.status == "holding"
        else
        end
      when 'Weapon','Collar','Sensor','Mantle'
        if belonging.status == "holding"
        else
        end
      when 'Ornament'
        "decorative"
      when 'Charm'
        if belonging.status == "holding"
        else
        end
      when 'Standard'
        "for pack"
    end
  end
end