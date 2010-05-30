set :user, 'tertirumshell'
set :domain, 'battlepet.net'  # Dreamhost servername where your account is located 
set :project, 'Battle-Pet-Network'  # Your application as its called in the repository
set :application, 'battlepet.net'  # Your app's location (domain or sub-domain name as setup in panel)
set :applicationdir, "/home/#{user}/#{application}"  # The standard Dreamhost setup

set :scm, 'git'
set :repository,  "git@github.com:Bellwether/Battle-Pet-Network.git"
set :deploy_via, :copy # :remote_cache
set :deploy_to, "/home/tertirumshell/battlepet.net"
set :branch, 'master'
set :git_shallow_clone, 1
set :scm_verbose, true

role :web, domain
role :app, domain
role :db,  domain, :primary => true

# additional settings

default_run_options[:pty] = true  # Forgo errors when deploying from windows
ssh_options[:keys] = %w(/Users/travidunn/.ssh/id_rsa)
set :chmod755, "app config db lib public vendor script script/* public/disp*"
set :use_sudo, false
set :keep_releases, 2

# Helpers

def environment
  if exists?(:stage)
    stage
  elsif exists?(:rails_env)
    rails_env
  elsif(ENV['RAILS_ENV'])
    ENV['RAILS_ENV']
  else
    "production"
  end
end

def run_rake(task)
  run "cd #{current_path} && rake #{task} RAILS_ENV=#{environment}"
end

#	Post Deploy Hooks

namespace :deploy do
  desc "Runs after every successful deployment"
  task :after_default do
    cleanup # removes the old deploys
  end
end

#	Passenger

namespace :deploy do
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end
 
  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
end