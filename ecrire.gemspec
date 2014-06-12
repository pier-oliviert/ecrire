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

  s.add_dependency 'railties',      '~> 4.1'
  s.add_dependency 'activerecord',  '~> 4.1'

  s.add_development_dependency 'debugger', '~> 1.6'

end
