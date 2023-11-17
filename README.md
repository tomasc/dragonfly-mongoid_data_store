# Dragonfly::MongoidDataStore

[![Tests](https://github.com/tomasc/dragonfly-mongoid_data_store/actions/workflows/test.yml/badge.svg)](https://github.com/tomasc/dragonfly-mongoid_data_store/actions/workflows/test.yml)

[Dragonfly](https://github.com/markevans/dragonfly) data store that uses [Mongoid::GridFs](https://github.com/ahoward/mongoid-grid_fs).

Data store similar to [dragonfly-mongo_data_store](https://github.com/markevans/dragonfly-mongo_data_store) which works with [Dragonfly](https://github.com/markevans/dragonfly) > 1 and [Mongoid](https://github.com/mongoid/mongoid) > 4.

## Requirements

* mongoid 5, 6 or 7

## Installation

Add this line to your application's Gemfile:

    gem 'dragonfly-mongoid_data_store'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dragonfly-mongoid_data_store

## Usage

You can configure Dragonfly to use the mongoid datastore in the dragonfly initializer like so:

```ruby
# config/initializers/dragonfly.rb

require 'dragonfly/mongoid_data_store'

Dragonfly.app.configure do
  # ...

  datastore :mongoid

  # ...
end
```

Remember the require!

## Contributing

1. Fork it ( https://github.com/tomasc/dragonfly-mongoid_data_store/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
