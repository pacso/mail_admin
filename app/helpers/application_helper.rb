module ApplicationHelper
  
  def class_for_alert_type(type)
    case type
    when 'notice'
      "success"
    when 'alert'
      "error"
    else
      type
    end
  end
  
  def status_label(status)
    if status
      render partial: 'layouts/enabled'
    else
      render partial: 'layouts/disabled'
    end
  end
end
