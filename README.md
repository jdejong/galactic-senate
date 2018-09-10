# GalacticSenate

GalacticSenate is a gem that provides a distributed leader 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'galactic-senate'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install galactic-senate

## Configuration

Create an initializer to setup the configuration variables of the GEM.

Setting the redis server to connect to is required.

```
   require 'galactic-senate'
   
   GalacticSenate.configure do |config|
     config.redis = Redis.current
     config.logger = Rails.logger
   
     config.on(:elected) do
       Rails.logger.warn "I was just elected!!"
     end
   
     config.on(:ousted) do
       Rails.logger.warn "I was just ousted!!"
     end
   end
```

### Configuration Variables

#### Redis

#### Logger

#### Callbacks

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jdejong/galactic-senate. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Galactic::Senate project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/galactic-senate/blob/master/CODE_OF_CONDUCT.md).
