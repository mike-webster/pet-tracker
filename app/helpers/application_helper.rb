module ApplicationHelper
  def show_local_time(time)
    return time.strftime("%Y-%m-%d %H:%M %Z") if @current_user.nil? || @current_user.timezone.blank?
    return time.in_time_zone(@current_user.timezone).strftime("%Y-%m-%d %H:%M %Z") 
  end
end
