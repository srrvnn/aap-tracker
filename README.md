# manifesto-tracker
Manifesto tracker

To rerun all migrations:
Run
    rake db:migrate:reset
or
    rake db:drop db:create db:migrate

To double check the state of the db:
Use the command
    rails dbconsole
Within sqlite3:
    .schema
