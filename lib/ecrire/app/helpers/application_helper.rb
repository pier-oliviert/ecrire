##
# +ApplicationHelper+ provides functions to help build a theme's layout
#
module ApplicationHelper
  ##
  # Render <title> tag
  #
  # The content of the title tag can be one of three things.
  # In priority of order:
  # 1. The value of content_for(:title) if it's set,
  # 2. The title of the variable @post, if it's set,
  # 3. The +title+ passed
  #
  # If you need more information about content_for and how to use it, please read:
  # http://ecrire.io/posts/configure-layout-element-with-content_for
  #
  def title_tag(title = 'Ecrire')
    content_tag :title do
      if content_for?(:title)
        content_for(:title)
      elsif defined? @post
        @post.title.name
      else
        title
      end
    end
  end

  ##
  # Render a RSS auto-discovery tag
  #
  # You can pass another relative path if you want.
  # Ecrire will render an absolute path using the +relative_path+
  #
  def rss_tag(relative_path = '/feed')
    content_tag :link, nil, rel: 'alternate', type: 'application/rss+xml', title: 'RSS', href: url(relative_path, absolute_path: true)
  end


  ##
  # Render the favicon tag
  #
  # Will generate the asset url given with the +name+ of your favicon.
  #
  def favicon_tag(name = 'favicon.ico')
    content_tag :link, nil, rel: %w(shortcut icon), href: image_path(name)
  end

  ##
  # Render the <main> tag
  #
  # The +html_options+ is a hash that will map to key/value for the tag.
  # Unless you know what you are doing, you should not specify an id in +html_options+.
  # Ecrire will generate one using the controller and action for the given request.
  #
  # You can also provide any key/value that you wish to see rendered in the main tag.
  # 
  # Example with posts#index (/posts):
  #
  #   <%= main_tag contentEditable: true do %>
  #     Hello world!
  #   <% end %>
  #   
  #   <main contentEditable=true id='PostsIndex'>
  #     Hello world!
  #   </main>
  #
  # Another example with posts#index (/posts):
  #
  #   <%= main_tag class: 'content' do %>
  #     Hello World!
  #   <% end %>
  #
  #   <main class='content' id='PostsIndex'>
  #     Hello World!
  #   </main>
  #
  #
  def main_tag(html_options = {}, &block)
    html_options[:id] ||= [controller_name, action_name].map(&:capitalize).join
    html_options[:class] = [html_options[:class]].compact.flatten
    if content_for?(:class)
      html_options[:class].concat content_for(:class).split(' ')
    end
    content_tag :main, html_options, &block
  end

  ##
  # Render a popup tag
  #
  def popup_tag(partial = nil, html_options = {}, &block)
    html_options.reverse_merge!({
      as: 'Popup',
      id: 'Popup',
      class: 'popup',
      overlay: true
    })

    if html_options.delete(:overlay) == true
      content_tag :div, class: %w(overlay), as: 'Overlay' do
        content_tag :div, partial, html_options, &block
      end
    else
      content_tag :div, partial, html_options, &block
    end
  end

end
