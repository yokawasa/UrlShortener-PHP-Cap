# UrlShortener-PHP-Cap
An example [Capistrano](http://capistranorb.com/) Capfile for deploying [UrlShortener-PHP](https://github.com/yokawasa/UrlShortener-PHP)

## Getting started
### Requirements
- PHP 5.*
- Capistrano v3
- Git

### Installation 
Download and install Capistrano 3 using gem:  

     $ sudo apt-get install ruby
     $ sudo apt-get install rubygems
     $ sudo gem install capistrano --no-ri --no-rdoc

Also install git & PHP if not yet installed:  

     $ sudo apt-get install git
     $ sudo apt-get install php5

### Download
     $ git clone https://github.com/yokawasa/UrlShortener-PHP-Cap.git
     $ cd UrlShortner-PHP-Cap
     $ find .
      ./config
      ./config/deploy
      ./config/deploy/production.rb
      ./config/deploy.rb
      ./lib
      ./lib/capistrano
      ./lib/capistrano/tasks
      ./Capfile

### Usage
Configure deploying target & database info: **UrlShortener-PHP-Cap/config/deploy/production.rb**  

     server '<deployserver>', user: '<deployuser>', port: 22, password: fetch(:password), roles: %w{web}
     set :db_server,    '<mysqlserver>:<port>'
     set :db_user,      '<dbuser>'
     set :db_password,  '<dbpassword>'
     set :db_name,      '<database>'

- \<deployserver\>: server hostname to deploy  ex) deployserver.cloudapp.net
- \<deployuser\>: login user to use for deployment in deploy server
- \<mysqlserver\>:\<port\>: MySQL server hostname and port to which UrlShortener-PHP app connects
- \<dbuser\>:   MySQL user for the application
- \<dbpassword\>:   MySQL user password for the application
- \<database\>:   MySQL Database name

Here are sample configuration  

     server 'deploying.cloudapp.net', user: 'yoichika', port: 22, password: fetch(:password), roles: %w{web}
       
     set :db_server,    'appdeploydemo.cloudapp.net:3306'
     set :db_user,      'demosa'
     set :db_password,  'demosaps'
     set :db_name,      'demo'


Once you configure production.rb or whatever deploy target info, run with the following cap command to deploy:  

    $ cap production deploy 

     




