source 'https://rubygems.org'

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Specify your gem's dependencies in dragonfly-mongoid_data_store.gemspec
gemspec

case version = ENV['MONGOID_VERSION'] || '~> 7.0'
when /7/ then gem 'mongoid', '~> 7.0'
when /6/ then gem 'mongoid', '~> 6.0'
when /5/ then gem 'mongoid', '~> 5.1'
else gem 'mongoid', version
end
