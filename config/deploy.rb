require './config/boot'
#require 'airbrake/capistrano'
require "bundler/capistrano"
require 'hipchat/capistrano'
#require "delayed/recipes"

## RBENV
set :default_environment, {
  'PATH' => "/home/deploy/.rbenv/shims:/home/deploy/.rbenv/bin:$PATH"
}

set :bundle_flags, "--deployment --quiet --binstubs --shebang ruby-local-exec"
## ENV RBENV
#

## FOR ASSETS PIPELINE, ETC
load 'deploy/assets'


set :application, "deploy"
set :repository,  "git@github.com:railsrumble/r12-team-31.git"
set :user, "deploy"
set :use_sudo, false

set :scm, :git
set :deploy_to, "/home/deploy/scrapsapp/"
set :branch, :master

role :web, "scrapsapp.com"                          # Your HTTP server, Apache/etc
role :app, "scrapsapp.com"                          # This may be the same as your `Web` server
role :db,  "scrapsapp.com", :primary => true # This is where Rails migrations will run

set :hipchat_token, ENV['HIPCHAT_TOKEN']
set :hipchat_room_name, "deployments"
set :hipchat_announce, false # notify users
set :hipchat_human, "ScrapsApp"

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart do
    sudo "touch #{current_path}/tmp/restart.txt"
  end

  task :symlink_uploads, :except => { :no_release => true } do
    run "ln -nfs #{shared_path}/uploads #{release_path}/public/uploads"
  end
  task :symlink_images, :except => { :no_release => true } do
    run "ln -nfs #{shared_path}/images #{release_path}/public/images"
  end
  task :symlink_media, :except => { :no_release => true } do
    run "ln -nfs #{shared_path}/media #{release_path}/public/media"
  end
  task :symlink_log, :except => { :no_release => true } do
    run "ln -nfs #{shared_path}/log #{release_path}/log"
  end
  after "deploy:finalize_update", "deploy:symlink_log"
  after "deploy:finalize_update", "deploy:symlink_uploads"
  after "deploy:finalize_update", "deploy:symlink_images"
  after "deploy:finalize_update", "deploy:symlink_media"
end

namespace :db do
  task :symlink, :except => { :no_release => true } do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
  after "deploy:finalize_update", "db:symlink"
end

#after "deploy:stop",    "delayed_job:stop"
#after "deploy:start",   "delayed_job:start"
#after "deploy:restart", "delayed_job:restart"

#https://gist.github.com/178397
#https://github.com/collectiveidea/delayed_job/issues/3

#namespace :delayed_job do
  #desc "Restart the delayed_job process"
  #task :restart, :roles => lambda { roles } do
    #stop
    #wait_for_process_to_end('delayed_job')
    #start
  #end

  #def wait_for_process_to_end(process_name)
    #run "COUNT=1; until [ $COUNT -eq 0 ]; do COUNT=`ps -ef | grep -v 'ps -ef' | grep -v 'grep' | grep -i '#{process_name}'|wc -l` ; echo 'waiting for #{process_name} to end' ; sleep 2 ; done"
  #end
#end

namespace :deploy do
  namespace :assets do
    task :precompile, :roles => :web, :except => { :no_release => true } do
      from = source.next_revision(current_revision)
      if capture("cd #{latest_release} && #{source.local.log(from)} vendor/assets/ app/assets/ | wc -l").to_i > 0
        run %Q{cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile}
      else
        logger.info "Skipping asset pre-compilation because there were no asset changes"
      end
    end
  end
end



        require './config/boot'
        require 'airbrake/capistrano'
