# README

## This project is a tool to help manage the health of a PostgreSQL database.

Currently the projects lists the activity on the DB with the option to issue a `pg_cancel_backend` command to any of the running pids.

![Screen Shot 2019-09-22 at 9 34 13 PM](https://user-images.githubusercontent.com/1371190/65397907-c6f55f80-dd81-11e9-8dbb-c24b6b612a58.png)

To run locally:
```
update database.yml
bundle install
yarn install
rails s
```
