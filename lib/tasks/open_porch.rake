namespace :open_porch do
  
  desc "Send Issues"
  task :issues_send => :environment do
    Issue.scheduled_before(Time.now).each do |issue|
      issue.send!
    end
  end
  
end