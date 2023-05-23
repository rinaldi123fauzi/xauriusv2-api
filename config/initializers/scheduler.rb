require 'rufus-scheduler'

# Initialize the scheduler
scheduler = Rufus::Scheduler.new

# Schedule the job using cron-like syntax
scheduler.cron '0 10 * * *' do
  # Code to execute at 10:00 AM every day
  # Replace this with your desired task
  puts "Job running at 10:00 AM"
end

# Start the scheduler
scheduler.join
