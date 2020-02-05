module ApplicationHelper
  def show_local_time(time)
    time_format = "%Y-%m-%d %H:%M"
    return time.strftime(time_format) if @current_user.nil? || @current_user.timezone.blank?
    return time.in_time_zone(@current_user.timezone).strftime(time_format) 
  end
end
