module Ecrire
  class RouteSet < ActionDispatch::Routing::RouteSet

    def draw(&block)
      @prepend.each { |blk| eval_block(blk) }
      eval_block(block)
      finalize!
      nil
    end

    def clear!
      @finalized = false
      named_routes.clear
      set.clear
      formatter.clear
      @append.clear
    end
  end
end
