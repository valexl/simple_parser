#### For testing application you have to run static_pages application on localhost:3000:

1) Go to workspace directory
2) Clone static_pages application - `git clone git@github.com:valexl/static_pages.git`
3) `cd ./static_pages && bundle install && rails s`

#### Also you have to clone current application:
1) Open another tab
2) Go to workspace directory
3) Clone application - `git clone git@github.com:valexl/simple_parser.git`
4) `cd ./simple_parser && bundle install && bundle exec rake db:migrate && rails s -p 3001`

#### Also you have to install redis:
1) Open new tab
2) Install redis: `brew install redis`
3) Run redis: `redis-server`
4) Current application uses resque and so you have to run resque in your console:
`TERM_CHILD=1 QUEUES=* rake resque:work`
5) Visit localhost:3001 and try how it works
