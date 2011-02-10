every 5.minutes do
  rake "open_portch:send_issues"
end

# 1. Add the following line at the beginning of the deploy script
# require "whenever/capistrano"

# 2. Append the followingto namespace :deploy
# desc "Update the crontab file"
# task :update_crontab, :roles => :db do
#   run "cd #{release_path} && whenever --update-crontab #{application}"
# end
