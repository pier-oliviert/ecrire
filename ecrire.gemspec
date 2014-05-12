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

  s.files         = Dir['README.md', 'lib/**/*']
  s.bindir      = 'bin'
  s.executables = ['ecrire']

  s.require_path  = 'lib'

  s.add_dependency 'activesupport', '~> 4.1'
  s.add_dependency 'actionpack',    '~> 4.1'
  s.add_dependency 'actionview',    '~> 4.1'
  s.add_dependency 'activemodel',   '~> 4.1'
  s.add_dependency 'activerecord',  '~> 4.1'
  s.add_dependency 'actionmailer',  '~> 4.1'
  s.add_dependency 'railties',      '~> 4.1'
  s.add_dependency 'thin',          '~> 1.6'
  s.add_dependency 'warden',        '~> 1.2'
  s.add_dependency 'bcrypt',        '~> 3.1'
  s.add_dependency 's3',            '~> 0.3'
  s.add_dependency 'pg',            '~> 0.17'
  s.add_dependency 'sass-rails',    '~> 4.0'
  s.add_dependency 'coffee-rails',  '~> 4.0'
  s.add_dependency 'jquery-rails',  '~> 3.1'
  s.add_dependency 'turbolinks',    '~> 2.2'
  s.add_dependency 'kaminari',      '~> 0.15'
  s.add_dependency 'cubisme',       '~> 0.2'

  s.add_development_dependency 'debugger', '~> 1.6'

end
