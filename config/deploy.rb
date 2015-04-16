# config valid only for current version of Capistrano
lock '3.4.0'

# set :application, 'my_app_name'
# set :repo_url, 'git@example.com:me/my_repo.git'
set :application,   'UrlShortener-PHP'
set :current_user,  ENV['USER']
set :repo_url,      'https://github.com/yokawasa/UrlShortener-PHP.git'
set :checkout_dir,  "/tmp/#{fetch(:current_user)}/#{fetch(:application)}/c"
set :archive_dir,   "/tmp/#{fetch(:current_user)}/#{fetch(:application)}"
set :upload_dir,    "/tmp/#{fetch(:current_user)}/#{fetch(:application)}"
set :release_path,  '/var/www/html'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5


task :checkout do
    run_locally do
        checkout_dir = fetch :checkout_dir
        repo_url = fetch :repo_url
        db_server = fetch :db_server
        db_user = fetch :db_user
        db_password = fetch :db_password
        db_name = fetch :db_name
        execute "rm -rf #{checkout_dir}"
        execute "mkdir -p #{checkout_dir}"
        execute "git clone #{repo_url} #{checkout_dir}"
        execute "find #{checkout_dir} -name \".git\" -type d | xargs rm -rf"
        if test "[ -e /usr/local/bin/composer ]"
	    execute "cd #{checkout_dir}/source && composer install"
        else
            execute "curl -sS https://getcomposer.org/installer | php && mv composer.phar #{checkout_dir}/composer"
            execute "cd #{checkout_dir}/source &&  #{checkout_dir}/composer install"
        end
         
         execute "mv #{checkout_dir}/source/src/Khepin/UrlShortener.php #{checkout_dir}/source/src/Khepin/UrlShortener.php.ORG"
         execute "sed -e \"{s,<__DB_SERVER__>,#{db_server},g; s,<__DB_USER__>,#{db_user},g; s,<__DB_PASSWORD__>,#{db_password},g; s,<__DB_NAME__>,#{db_name},g}\" #{checkout_dir}/source/src/Khepin/UrlShortener.php.ORG >  #{checkout_dir}/source/src/Khepin/UrlShortener.php"

    end
end 

task :archive => :checkout do
    run_locally do
        checkout_dir = fetch :checkout_dir
        archive_dir = fetch :archive_dir
        application = fetch :application
        unless test "[ -d #{archive_dir} ]"
            execute "mkdir -p #{archive_dir}"
        end
        execute "tar cvfz #{archive_dir}/#{application}.tar.gz -C #{checkout_dir}/source ."
    end
end

task :deploy => :archive do
    on roles(:web) do
        archive_dir = fetch :archive_dir
        application = fetch :application
        upload_dir = fetch :upload_dir
        release_path = fetch :release_path
        unless test "[ -d #{upload_dir} ]"
            execute "mkdir -p #{upload_dir}"
        end
        
        upload! "#{archive_dir}/#{application}.tar.gz", "#{upload_dir}/#{application}.tar.gz"
        execute "cd #{release_path}; sudo tar -zxvf #{upload_dir}/#{application}.tar.gz"
        if test "[ -e #{release_path}/index.html ]"
            execute "sudo mv #{release_path}/index.html #{release_path}/index.html__"
        end
        execute "sudo service apache2 restart"
    end
end

#namespace :deploy do
#
#  after :restart, :clear_cache do
#    on roles(:web), in: :groups, limit: 3, wait: 10 do
#      # Here we can do anything such as:
#      # within release_path do
#      #   execute :rake, 'cache:clear'
#      # end
#    end
#  end
#
#end
