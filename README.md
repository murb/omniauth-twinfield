# Omniauth Twinfield Strategy

An very minimal OmniAuth Strategy for Twinfield, a bookkeeping package.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'omniauth-twinfield'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install omniauth-twinfield

## Usage

Configuring Omniauth:

    provider :twinfield, Rails.application.secrets.oauth_twinfield_id, Rails.application.secrets.oauth_twinfield_secret

Configuration for Devise (using omniauthable):

    config.omniauth :twinfield, Rails.application.secrets.oauth_twinfield_id, Rails.application.secrets.oauth_twinfield_secret

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and merge requests are welcome on GitLab at https://gitlab.com/murb-org/omniauth-twinfield. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://gitlab.com/murb-org/omniauth-twinfield/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Omniauth::Twinfield project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://gitlab.com/murb-org/omniauth-twinfield/blob/master/CODE_OF_CONDUCT.md).
