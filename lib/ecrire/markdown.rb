require 'ecrire/markdown/document'

module Ecrire
  module Markdown

    def self.parse(str)
      document = Document.new(str)
      document.parse!
      document
    end

  end
end
