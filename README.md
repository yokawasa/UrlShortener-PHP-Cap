# UrlShortener-PHP-Cap
An example capistrano capfile for deploying [UrlShortener-PHP](https://github.com/yokawasa/UrlShortener-PHP)

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
Configure deploying target & database info - UrlShortener-PHP-Cap/config/deploy/production.rb

 server '<DeployServer>', user: '<DeployUser>', port: 22, password: fetch(:password), roles: %w{web}
 set :db_server,    '<MySql Server>:<Port>'
 set :db_user,      '<DB User>'
 set :db_password,  '<DB Password>'
 set :db_name,      '<Database>'

- <DeployServer>: server hostname to deploy  ex) deployserver.cloudapp.net
- <DepployUser>: login user to use for deployment in deploy server  ex) deploy
- <MySql Server>:<Port>: MySQL server hostname & Port to which UrlShortener-PHP app connects ex) mysql.cloudapp.net:3306
- <DB user>:   MySQL user for the application
- <DB password>:   MySQL user password for the application
- <Database>:   MySQL Database name

Here are sample configuration
 server 'deploying.cloudapp.net', user: 'yoichika', port: 22, password: fetch(:password), roles: %w{web}
 
 set :db_server,    'appdeploydemo.cloudapp.net:3306'
 set :db_user,      'demosa'
 set :db_password,  'demosaps'
 set :db_name,      'demo'
