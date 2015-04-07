module Ecrire
  module Markdown
    module Parsers
      autoload :Base,       'ecrire/markdown/parsers/base'
      autoload :Word,       'ecrire/markdown/parsers/word'
      autoload :List,       'ecrire/markdown/parsers/list'
      autoload :Image,      'ecrire/markdown/parsers/image'
      autoload :Code,       'ecrire/markdown/parsers/code'
      autoload :Heading,    'ecrire/markdown/parsers/heading'
      autoload :Link,       'ecrire/markdown/parsers/link'
    end
  end
end
