ssh_options[:forward_agent] = true
set :rake,    '/opt/ruby-enterprise/bin/rake'
set :bundle,  '/opt/ruby-enterprise/bin/bundle'
set :ruby,    '/opt/ruby-enterprise/bin/ruby'
set :god_init, '/etc/init.d/god'
set :god_bin,  '/opt/ruby-enterprise/bin/god'

set :use_sudo,      false

set :application, "caritas"
set :repository,  "git@nomad-labs.dyndns.org:caritas.git"
set :branch,      "hotfix/I18n-missing"
set :deploy_to,   "/data/shoaib/caritas"
set :scm,         :git

role :web, "caritas.nomad-labs.com"                           # Your HTTP server, nginx/Apache/etc
role :app, "caritas.nomad-labs.com"                           # This may be the same as your `Web` server
role :db,  "caritas.nomad-labs.com", :primary => true         # This is where Rails migrations will run

namespace :deploy do
  task :start, :roles => :app do
    god.reload_websocket
    run "touch #{current_release}/tmp/restart.txt"
  end

  desc "Symlink shared configs and folders on each release."
  task :symlink_shared do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/uploads #{release_path}/public/uploads"
    # run "ln -nfs #{shared_path}/config/confidentials.rb #{release_path}/config/confidentials.rb"
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    god.reload_websocket
    run "touch #{current_release}/tmp/restart.txt"
  end
end

namespace :bundler do
  task :create_symlink, :roles => :app do
    shared_dir = File.join(shared_path, 'bundle')
    release_dir = File.join(current_release, '.bundle')
    run("mkdir -p #{shared_dir} && ln -s #{shared_dir} #{release_dir}")
  end
  
  task :bundle_new_release, :roles => :app do
    bundler.create_symlink
    run "cd #{release_path} && #{bundle} install --path .bundle --without test --without development"
  end
  
  task :lock, :roles => :app do
    run "cd #{current_release} && #{bundle} lock;"
  end
  
  task :unlock, :roles => :app do
    run "cd #{current_release} && #{bundle} unlock;"
  end
end

namespace :god do
  task :restart, :roles => :app do
    run "sudo #{god_init} restart"
  end

  desc "Reload config"
  task :reload_websocket, :roles => :app do
    run "sudo #{god_bin} load #{deploy_to}/current/config/god/websocket.god"
  end

  desc "Start god"
  task :start, :roles => :app do
    run "sudo #{god_init} start"
  end

  desc "Describe the status of the running tasks"
  task :status, :roles => :app do
    run "sudo #{god_bin} status"
  end
end

after "deploy:update_code" do
  bundler.bundle_new_release
  deploy.symlink_shared
  # deploy.migrations
  # deploy.load_seed
end


# require 'config/boot'
require './config/boot'
require 'airbrake/capistrano'
