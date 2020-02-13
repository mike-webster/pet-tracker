module ApplicationHelper
  def show_local_time(time)
    time_format = "%Y-%m-%d %H:%M"
    return time.strftime(time_format) if @current_user.nil? || @current_user.timezone.blank?
    return time.in_time_zone(@current_user.timezone).strftime(time_format) 
  end

  def show_line_chart(data)
    line_chart data, 
      xtitle: "Day", 
      ytitle:"Time", 
      xmin: Time.now.to_date - 5.days, 
      xmax: Time.now.to_date + 1.day,
      colors: ["#2BA84A", "#2D3A3A"]
  end
end
