# Delhi Government's Manifesto Tracker 2016

This is the repository that contains the code for Delhi Government's Manifesto
Tracker web application.

### setting up and running
----

##### Install Ruby, RubyGems, SQL3Lite, PostgreSQL:

        brew install ruby
        ruby -- version

        Download from https://www.sqlite.org/download.html
        sqlite3 --verison

        brew install postgresql
        psql --version

##### Install Project Dependencies:

        gem install bundle

        bundle install


##### Seed Database:

        rake db:migrate:reset
        rake db:drop db:create db:migrate
        rake db:seed


##### Run the server:

        bin/rails server

        open http://localhost:3000


### running tests
----

### updating schema
----

Print current database schema

        rails dbconsole
        .schema

### contributing
----
