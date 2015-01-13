lib = File.expand_path('../lib', __FILE__)
$:.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'ecrire/version'

Gem::Specification.new do |s|
  s.name        = 'ecrire'
  s.version     = Ecrire::VERSION
  s.summary     = 'Blog engine'
  s.description = 'Blog engine on Rails'

  s.required_ruby_version = '>= 2.0.0'

  s.license   = 'MIT'

  s.author        = 'Pier-Olivier Thibault'
  s.email         = 'pothibo@gmail.com'
  s.homepage      = 'http://pothibo.com'

  s.files         = `git ls-files -z`.split("\x0")
  s.files         += Dir['README.md']
  s.bindir        = 'bin'
  s.executables   = ['ecrire']

  s.require_path  = 'lib'

  s.add_dependency 'rails',    '~> 4.2'
  s.add_dependency 'jointjs',  '~> 0.0'
  s.add_dependency 'warden',   '~> 1.2'
  s.add_dependency 'bcrypt',   '~> 3.1'
  s.add_dependency 'nokogiri', '~> 1.6'
  s.add_dependency 's3',       '~> 0.3'
  s.add_dependency 'pg',       '~> 0.17'
  s.add_dependency 'kaminari', '~> 0.15'
  s.add_dependency 'kramdown', '~> 1.5'

end
