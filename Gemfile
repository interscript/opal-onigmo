source "https://rubygems.org"

# Specify your gem's dependencies in opal-onigmo.gemspec
gemspec

gem "rake", "~> 12.0"
gem "rspec", "~> 3.0"

gem "pry"

gem "opal", "~> 1.0"
if File.directory? __dir__+"/../opal-webassembly"
  gem "opal-webassembly", path: __dir__+"/../opal-webassembly"
else
  gem "opal-webassembly"
end
gem "opal-rspec"
