module ApplicationHelper
  
  def generate_title(title)
    full_title = "Facebook on Rails"
    full_title.prepend "#{title} - " unless title.blank?
    full_title
  end
    
  def use_google_data
    google_data = session['devise.google_data'] && session['devise.google_data']['info']
    if google_data
      session.delete('devise.google_data')
      @user = User.new(email: google_data['email'],
                       first_name: google_data['first_name'],
                       last_name: google_data['last_name'])
    else
      @user = User.new
    end
  end
  
  def bootstrap_status_class(status)
    status_hash = { "notice" => "info", "alert" => "danger" }
    status_hash[status].nil? ? status : status_hash[status]
  end
  
  def link_with_icon(icon_css, title, url, options = {})
    title_with_icon = "#{icon(*icon_css)} #{title}".html_safe
    link_to(title_with_icon, url, options)
  end
end
