[![Code Climate](https://codeclimate.com/github/railslink/railslink/badges/gpa.svg)](https://codeclimate.com/github/railslink/railslink)
[![Circle CI](https://circleci.com/gh/railslink/railslink.svg?style=shield)](https://circleci.com/gh/railslink/railslink)
[![Coverage Status](https://coveralls.io/repos/railslink/railslink/badge.svg?branch=coverage&service=github)](https://coveralls.io/github/railslink/railslink?branch=coverage)

# Ruby on Rails Link

http://www.rubyonrails.link

Official website of Ruby on Rails Link.

## Getting Started

### Requirements

- Ruby 2.7.4
- PostgreSQL 10+
- Redis 4+

### Contributing

  - *Using Docker...*

    - Start it up: `docker-compose up -d`
    - Create the database: `docker-compose run --rm web rake db:setup`

  - *Not using Docker...*

    - Install gems: `bundle install`
    - Create the database: `rake db:setup`
    - Start the Rails server: `rails s`

  - Visit http://localhost:3000/admin and verify you can login and see the
    admin dashboard.

### Interacting with Slack

Depending on what you are doing you can get started without needing to interact
with our Slack instance. However, if you do need it:

  - Join the Railslink-dev Slack team by requesting an invitation (we'll need
    your email) in the official #railslink-dev channel.

  - Ask an existing member of Railslink-dev to make you an admin.

  - Acquire the missing Railslink-dev ENV vars in `.env` from another Slack
    member (ie. phallstrom).  Add them to `.env.local`.

  - *Using Docker...*

    - Test the Slack API: `docker-compose run --rm web rake slack:test:api`
    - Sync Slack channels: `docker-compose run --rm web rake slack:sync:channels`
    - Optionally sync Slack users: `docker-compose run --rm web rake slack:sync:users`

  - *Not using Docker...*

    - Test the Slack API: `rake slack:test:api`
    - Sync Slack channels: `rake slack:sync:channels`
    - Optionally sync Slack users: `rake slack:sync:users`
