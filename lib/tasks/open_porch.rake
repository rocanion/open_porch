namespace :open_porch do
  
  desc "Send Issues"
  task :send_issues => :environment do
    Issue.scheduled_before(Time.now).each do |issue|
      issue.send!
    end
  end
  
end