Gem::Specification.new do |s|
  s.name        = 'ecrire'
  s.version     = Ecrire::Version
  s.summary     = 'Blog engine'
  s.description = 'Blog engine on Rails'

  s.required_ruby_version = '>= 2.0.0'

  s.license   = 'MIT'

  s.author        = 'Pier-Olivier Thibault'
  s.email         = 'pothibo@gmail.com'
  s.homepage      = 'http://pothibo.com'

  s.files         = Dir['README.md', 'lib/**/*']
  s.require_path  = 'lib'

  s.add_dependency 'rails',         '~> 4.0'
  s.add_dependency 'thin',          '~> 1.6.2'
  s.add_dependency 'warden',        '~> 1.2.3'
  s.add_dependency 'bcrypt',        '~> 3.1'
  s.add_dependency 's3',            '~> 0.3'
  s.add_dependency 'pg',            '~> 0.17.1'
  s.add_dependency 'sass-rails',    '~> 4.0.0'
  s.add_dependency 'uglifier',      '>= 1.3.0'
  s.add_dependency 'coffee-rails',  '~> 4.0.0'
  s.add_dependency 'jquery-rails',  '~> 3.1.6'
  s.add_dependency 'turbolinks',    '~> 2.2.2'
  s.add_dependency 'jbuilder',      '~> 2.0.6'
  s.add_dependency 'kaminari',      '~> 0.15.1'
  s.add_dependency 'cubisme',       '~> 0.2.3'
  s.add_dependency 'exits',         '~> 0.0.4'

  s.add_development_dependency 'debugger', '~> 1.6.6'

end
