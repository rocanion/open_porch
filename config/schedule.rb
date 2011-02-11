every 5.minutes do
  rake "open_porch:send_issues"
end

# Add the following line at the beginning of the deploy script
# require "whenever/capistrano"
