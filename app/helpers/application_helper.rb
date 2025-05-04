module ApplicationHelper
  def display_event_name(event)
    if defined?(event) && event.present? && event.respond_to?(:id) && event.id.present?
      event.name
    else
      "テニスの乱数表"
    end
  end
end
