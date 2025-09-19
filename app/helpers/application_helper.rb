module ApplicationHelper
  def bootstrap_class_for(flash_type)
    case flash_type.to_sym
    when :success then "success"
    when :error   then "danger"
    when :alert   then "warning"
    when :notice  then "info"
    else flash_type.to_s
    end
  end

  def page_title(default: "Readnest", title: nil)
    [title, default].compact.join(" · ")
  end

  def meta_description(text = nil)
    truncate(strip_tags(text.presence || "Chroniques littéraires, maisons d’édition et librairies — Readnest."), length: 160)
  end
end
