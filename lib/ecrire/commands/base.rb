module Ecrire
  module Commands
    class Base
      def shift_argv!
        ARGV.shift if ARGV.first && ARGV.first[0] != '-'
      end
    end
  end
end
