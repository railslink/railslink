[![Code Climate](https://codeclimate.com/github/railslink/railslink/badges/gpa.svg)](https://codeclimate.com/github/railslink/railslink) [![Circle CI](https://circleci.com/gh/railslink/railslink.svg?style=svg)](https://circleci.com/gh/railslink/railslink)

# Ruby on Rails Link

http://www.rubyonrails.link

Official website of Ruby on Rails Link.


## Getting Started

### Dependencies
Make sure you have installed bundler and PostgreSQL and created railslink user.

```
# if you need to install postgresql on mac

brew install postgresql
```

### Setup

Clone this repo and do the following:

```
cp config/database.example.yml config/database.yml
cp config/secrets.example.yml config/secrets.yml
```

Update those files with your local configuration and then run:

```
bundle
bundle exec rake db:create
bundle exec rails s
````
