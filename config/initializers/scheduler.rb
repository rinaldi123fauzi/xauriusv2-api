require 'rufus-scheduler'

# Initialize the scheduler
# scheduler = Rufus::Scheduler.new
scheduler = Rufus::Scheduler.singleton

# Schedule the job using cron-like syntax
scheduler.cron '0 10 * * *' do
  # Code to execute at 10:00 AM every day
  # Replace this with your desired task
  puts "Job running at 10:00 AM"

end

# Schedule the job using cron-like syntax
scheduler.cron '5 9 * * *' do
# scheduler.cron '* * * * *' do
  # Code to execute at 10:00 AM every day
  # Replace this with your desired task
  puts "Jalan setiap jam 9:05 am"
  GetAntamTablePrice.perform_now
  GetAntamPrice.perform_now

end

# Start the scheduler
# scheduler.join
