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
  
  def setting_status(status)
    if status
      render partial: 'layouts/setting_enabled'
    else
      render partial: 'layouts/setting_disabled'
    end
  end
end
