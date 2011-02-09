module ApplicationHelper
  
  # == show_user_activity ===================================================
    # options[:url]  is the url for the page that should be queried
    # options[:should_update] if true send updates for the current page
  
  # Add this code once on every page show_user_activity is called  
  # content_for (:head) do 
  #   javascript_include_tag 'user_activity'
  # end
    
  def show_user_activity(options = {})
    options[:url] ||= ''
    options[:should_update] ||= false
    
    content_for(:doc_ready) do
      output = %{get_user_activity('#{current_user.full_name}', '#{options[:url]}', '#{UserActivity.EXPIRES*1000}');} # multiply by 1000 because javascript requires miliseconds
      if (options[:should_update])
        output += %{update_user_activity('#{current_user.full_name}', '#{options[:url]}', '#{UserActivity.EXPIRES*1000}');}
      end      
      raw output
    end
    
    content_tag(:div, '', :id => 'user_activity')
  end
  
end