# Opal::Onigmo

Execute regexps in Opal with a native Ruby regexp engine - Onigmo - compiled using clang to WebAssembly.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'opal-onigmo'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install opal-onigmo

## Usage

```ruby
# In your Opal code

require 'onigmo'
r = Onigmo::Regexp.new("^ab+")
"abbbcd".gsub(r, "dd") # => "ddcd"
r.match("test") # => false

require 'onigmo/core_ext'
"test".match(r) # => false
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/opal-onigmo.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
