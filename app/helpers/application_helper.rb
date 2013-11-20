module ApplicationHelper
  def admin_access_bar
    content_tag :div, id: "adminAccessBar" do
      [
        link_to(t(".admin"), admin.root_path, class: %w(admin link)),
        button_to(t(".logout"), session_path, method: :delete)
      ].join.html_safe
    end
  end

  def title
    return @post.title unless @post.nil?
    return "pothibo's blog" 
  end
end
