every 5.minutes do
  rake "open_portch:send_issues"
end

# Add the following line at the beginning of the deploy script
# require "whenever/capistrano"
