# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dragonfly/mongoid_data_store/version'

Gem::Specification.new do |spec|
  spec.name          = 'dragonfly-mongoid_data_store'
  spec.version       = Dragonfly::MongoidDataStore::VERSION
  spec.authors       = ['Tomas Celizna']
  spec.email         = ['tomas.celizna@gmail.com']
  spec.summary       = 'Dragonfly data store that uses Mongoid::GridFs.'
  spec.description   = 'Dragonfly data store that uses Mongoid::GridFs.'
  spec.homepage      = 'https://github.com/tomasc/dragonfly-mongoid_data_store'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'dragonfly', '>= 1.0'
  spec.add_dependency 'mongoid'
  spec.add_dependency 'mongoid-grid_fs'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'database_cleaner', '>= 1.5.1'
  spec.add_development_dependency 'guard'
  spec.add_development_dependency 'guard-minitest'
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'rake', '~> 10.0'
end
