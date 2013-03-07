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
end
