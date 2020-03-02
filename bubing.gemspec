Gem::Specification.new do |s|
  s.name        = 'bubing'
  s.version     = '0.1.2'
  s.date        = '2016-05-07'
  s.summary     = 'Script for bundling linux binaries'
  s.description = 'Script for bundling linux binaries'
  s.authors     = ['Gleb Sinyavsky']
  s.email       = 'zhulik.gleb@gmail.com'
  s.executables << 'bubing'
  s.files       = %w(lib/bubing/binary_info.rb  lib/bubing/bundler_factory.rb  lib/bubing/bundler.rb
                     lib/bubing/executable_bundler.rb  lib/bubing.rb  lib/bubing/shared_object_bundler.rb)
  s.homepage    = 'http://rubygems.org/gems/bubing'
  s.license     = 'MIT'

  s.add_development_dependency 'bundler', '~> 1.12'
  s.add_development_dependency 'rake', '~> 12.3'

  s.add_development_dependency 'rspec',  '~> 3.4'
  s.add_development_dependency 'codeclimate-test-reporter', '~> 0.5'
end
