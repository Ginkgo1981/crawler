# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
# env :PATH, ENV['PATH']
#
# set :output, '/mnt/logs/cron.log'
#
# every 1.day, at: '10:40 pm' do
#   rake 'channel:enqueue_channels'
# end


# every :day, at: %w(10:18pm) do
#   rake 'channel:enqueue_channels > /mnt/logs/enqueue_channels.log 2>&1'
# end
#
#
# every :day, at: %w(10:20pm) do
#   rake 'channel:enqueue_links > /mnt/logs/enqueue_channels.log 2>&1'
# end
#
# every :day, at: %w(10:22pm) do
#   rake 'channel:fetch_and_enqueue_company_job_json > /mnt/logs/fetch_and_enqueue_company_job_json.log 2>&1'
# end

