module ApplicationHelper
  ALERT_TYPES = [:success, :info, :warning, :danger] unless const_defined?(:ALERT_TYPES)

  def link_to_glyph(glyph_class, name, path, options={})
    link_to path, options, {} do
      (content_tag :i, "", class: ["glyphicon", "glyphicon-#{glyph_class}"]) + " " + name
    end
  end

  def boolean_glyph(boolean_value)
    boolean_value ? (content_tag :i, "", class: ["glyphicon", "glyphicon-ok", "text-success"])
                  : (content_tag :i, "", class: ["glyphicon", "glyphicon-remove", "text-danger"])
  end

  def bootstrap_flash(options = {})
    flash_messages = []
    flash.each do |type, message|
      # Skip empty messages, e.g. for devise messages set to nothing in a locale file.
      next if message.blank?

      type = type.to_sym
      type = :success if type == :notice
      type = :danger  if type == :alert
      type = :danger  if type == :error
      next unless ALERT_TYPES.include?(type)

      Array(message).each do |msg|
        text = content_tag(:div,
                           content_tag(:button, raw("&times;"), :class => "close", "data-dismiss" => "alert") +
                           msg.html_safe, :class => "alert fade in alert-#{type} #{options[:class]}")
        flash_messages << text if msg
      end
    end
    flash_messages.join("\n").html_safe
  end
end
