##
# This module overloads the +paginate+ method defined 
# by Kaminari to force kaminari to use the routes provided by the theme.
#
# This might not be needed when Kaminari reaches 1.0 per https://github.com/amatsuda/kaminari/pull/636
#
module PaginationHelper
  
  ##
  # Returns pagination for the given scope(record).
  # 
  # The argument list is the same as the one declared by kaminari
  # to keep the expected behavior when calling ```super```
  #
  # Example:
  #
  # ``` erb
  # <%= paginate(@posts) %>
  # ```
  #
  def paginate(scope, options = {}, &block)
    _with_routes Ecrire::Theme::Engine.routes do
      super
    end
  end
end
