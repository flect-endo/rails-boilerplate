module PicturesHelper

  def format_resource_value(key, value)
    case key
    when "url"
      link_to "HTTP", value
    when "secure_url"
      link_to "HTTPS", value
    when "created_at"
      l Time.zone.parse(value)
    else
      value
    end
  end
end
