set :output, "log/cron.log"
job_type :exec, "cd :path && RAILS_ENV=:environment :task :output"

every 5.minutes do
  exec "./bin/pop3.rb"
end

# Add the following line at the beginning of the deploy script
# require "whenever/capistrano"
