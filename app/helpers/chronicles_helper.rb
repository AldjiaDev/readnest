module ChroniclesHelper
  def formatted_chronicle_content(text)
    return "" if text.blank?

    html = simple_format(h(text))

    html = html.gsub(%r{<p>&gt;\s*(.+?)</p>}m) do
      "<blockquote>#{$1}</blockquote>"
    end

    html.html_safe
  end
end
