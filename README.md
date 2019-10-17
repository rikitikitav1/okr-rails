# README

This is the small project for my OKR made in according to the RoR [tutorial](https://www.learnenough.com/ruby-on-rails-6th-edition)

## Ruby version

2.6.3

## Configuration

POSTGRES_PASSWORD - for db password in production environment
POSTGRES_USER - for db user in production environment
POSTGRES_DB - for db name in production environment
DB_HOST - for db host in production environment
DB_PORT - for db port in production environment

## Database docker  run example

`docker run --name okr-rails-db --env-file ./docker/env.list -p 5432:5432 -d postgres`
