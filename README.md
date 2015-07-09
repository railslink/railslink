[![Code Climate](https://codeclimate.com/github/railslink/railslink/badges/gpa.svg)](https://codeclimate.com/github/railslink/railslink) [![Circle CI](https://circleci.com/gh/railslink/railslink.svg?style=svg)](https://circleci.com/gh/railslink/railslink)

# Ruby on Rails Link

http://www.rubyonrails.link

Official website of Ruby on Rails Link.


## Getting Started

### Dependencies
Make sure you have installed bundler and PostgreSQL.

```
# if you need to install PostgreSQL on Mac with Homebrew

brew install postgresql
```

### Setup

Clone this repo and configure database.

If you already have a local PostgreSQL superuser, make `.env` file on project root and configure like this:

```
PG_USER=mysuperuser
PG_PASSWORD=mypassword
```

If you don't have a superuser yet, create railslink user, with password "railspgpw"

```
createuser -P -s -e railslink
```

Then run:

```
bundle
bundle exec rake db:create
bundle exec rails s
````
