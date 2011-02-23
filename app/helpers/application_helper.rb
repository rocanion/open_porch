module ApplicationHelper
  def show_user_activity_for_url(url)
    content_for(:doc_ready) do
      raw %{get_user_activity('#{current_user.full_name}', '#{url}', '#{UserActivity::EXPIRES * 1000 }');} # multiply by 1000 because javascript requires miliseconds
    end    
    content_tag(:div, '', :id => "user_activity")
  end
  
  def update_user_activity_for_url(url)
    content_for(:doc_ready) do
      raw %{update_user_activity('#{current_user.full_name}', '#{url}', '#{(UserActivity::EXPIRES-2) * 1000}');}
    end
  end

  def show_ad_for(zone_name, area)
    return unless defined?(OPEN_PORCH_ZONES)
    time = Time.now.to_i

    link_to("http://d1.openx.org/ck.php?cb=#{time}&n=a8417ca6", :class => "ad #{zone_name}", :target => '_blank') do
      image_tag("http://d1.openx.org/avw.php?zoneid=#{OPEN_PORCH_ZONES[zone_name.to_s]}&region=#{@area.slug}&cb=#{time}&n=a8417ca6")
    end
  end
end

