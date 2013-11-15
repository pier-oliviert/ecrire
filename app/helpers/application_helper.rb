module ApplicationHelper
  def title
    return @post.title unless @post.nil?
    return "pothibo's blog" 
  end
end
