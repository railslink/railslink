source 'https://rubygems.org'

ruby '2.7.4'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 6.1'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

gem 'dotenv-rails', groups: [:development, :test]                  # load environment variables from `.env`. must load before other gems

gem 'omniauth'                                                     # omniauth is a flexible authentication system utilizing rack middleware
gem 'omniauth-slack'                                               # the slack strategy for omniauth and supports the sign in with slack approval flow
gem 'configatron'                                                  # add multi-environment yaml settings
gem 'countries'                                                    # all sorts of useful information about every country
gem 'httparty'                                                     # http requests for callbacks to Slack slash command API
gem 'kramdown'                                                     # markdown parser
gem 'marginalia'                                                   # attach comments to your activerecord queries
gem 'oj'                                                           # fast json parser and object serializer
gem 'pg', '< 2.0'                                                  # use postgresql as the database
gem 'pagy'                                                         # pagination ruby gem
gem 'puma'                                                         # use puma as the app server
gem 'rack-attack'                                                  # rack middleware for blocking & throttling abusive requests
gem 'redis'                                                        # client that tries to match redis' api one-to-one, while still providing an idiomatic interface
gem 'rollbar'                                                      # exception tracking for ruby
gem 'sass-rails'                                                   # ruby on rails stylesheet engine for sass
gem 'slack-ruby-client'                                            # client for the slack web and real time messaging apis
gem 'slim-rails'                                                   # slim templates generator for rails 3, 4 and 5
gem 'sprockets'                                                    # sprockets is a rack-based asset packaging system that concatenates and serves javascript, scss, etc
gem 'sucker_punch'                                                 # asynchronous processing library
gem 'uglifier'                                                     # compressor for javascript assets
gem 'nokogiri'                                                     # a HTML, XML, SAX, and Reader parser

group :development, :test do
  gem 'rspec-rails'                                                # testing framework
  gem 'rspec_junit_formatter'                                      # rSpec results that your continuous integration service can read
  gem 'factory_bot_rails'                                          # provides integration between factory_bot and rails
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]              # ruby debugger
  gem 'pry-rails'                                                  # use pry as your rails console
  gem 'vcr'                                                        # record test suite's http interactions and replay them during future test runs
  gem 'webmock'                                                    # allows stubbing http requests and setting expectations on http requests
end

group :development do
  gem 'web-console'                                                # a debugging tool for ruby on rails applications
  gem 'listen'                                                     # listens to file modifications and notifies you about the changes
  gem 'ffi'                                                        # a foreign function interface ruby implementation
  gem 'seed_dump'                                                  # tasks to dump your data to db/seeds.rb
  gem "annotate"                                                   # annotate models with schema and routes info
end

group :test do
  gem 'fakeredis'                                                  # fake (in-memory) driver for redis-rb
  gem 'shoulda'                                                    # makes tests easy on the fingers and eyes
  gem 'stub_env'                                                   # helper to stub ENV variables in Rspec tests
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby] # windows does not include zoneinfo files, so bundle the tzinfo-data gem
