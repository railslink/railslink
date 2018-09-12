source 'https://rubygems.org'

ruby "2.4.4"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.1.5'

gem 'dotenv-rails', groups: [:development, :test]                  # load environment variables from `.env`. must load before other gems

gem "omniauth", '= 1.8.1'                                          # omniauth is a flexible authentication system utilizing rack middleware
gem "omniauth-slack", '= 2.3.0'                                    # the slack strategy for omniauth and supports the sign in with slack approval flow
gem 'configatron'                                                  # add multi-environment yaml settings
gem 'countries', '~> 2.1.4'                                        # all sorts of useful information about every country
gem 'oj', '~> 2.16.1'                                              # fast json parser and object serializer
gem 'pg', '>= 0.18', '< 2.0'                                       # use postgresql as the database
gem 'puma', '~> 3.7'                                               # use puma as the app server
gem 'rack-attack', '~> 5.2.0'                                      # rack middleware for blocking & throttling abusive requests
gem 'rails-assets-bulma', source: 'https://rails-assets.org'       # modern css framework based on flexbox
gem 'rails-assets-chartjs', source: 'https://rails-assets.org'     # html5 charts using the canvas element
gem 'rails-assets-fontawesome', source: 'https://rails-assets.org' # iconic svg, font, and css toolkit
gem 'redis', '~> 4.0.1'                                            # client that tries to match redis' api one-to-one, while still providing an idiomatic interface
gem 'rollbar', '~> 2.16.3'                                         # exception tracking for ruby
gem 'sass-rails', '~> 5.0'                                         # ruby on rails stylesheet engine for sass
gem 'slack-ruby-client', '~> 0.11'                                 # client for the slack web and real time messaging apis
gem 'slim-rails'                                                   # slim templates generator for rails 3, 4 and 5
gem "sprockets", "~> 3.7.2"                                        # sprockets is a rack-based asset packaging system that concatenates and serves javascript, scss, etc
gem 'sucker_punch', '~> 2.0'                                       # asynchronous processing library
gem 'uglifier', '>= 1.3.0'                                         # compressor for javascript assets

group :development, :test do
  gem 'rspec-rails', '~> 3.7'                                      # testing framework
  gem 'rspec_junit_formatter', '~> 0.3.0'                          # rSpec results that your continuous integration service can read
  gem 'factory_bot_rails', '~> 4.8'                                # provides integration between factory_bot and rails
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]              # ruby debugger
  gem 'pry-rails'                                                  # use pry as your rails console
end

group :development do
  gem 'web-console', '>= 3.3.0'                                    # a debugging tool for ruby on rails applications
  gem 'listen', '>= 3.0.5', '< 3.2'                                # listens to file modifications and notifies you about the changes
  gem 'ffi', '~> 1.9.24'                                           # a foreign function interface ruby implementation
end

group :test do
  gem 'fakeredis', '~> 0.7.0'                                      # fake (in-memory) driver for redis-rb
  gem 'shoulda', '~> 3.5'                                          # makes tests easy on the fingers and eyes
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby] # windows does not include zoneinfo files, so bundle the tzinfo-data gem

