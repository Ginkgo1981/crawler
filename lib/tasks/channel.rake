namespace :channel do
  desc 'read from channel, then enqueue links '
  task get_then_enqueue_links: :environment do
    site = Site.first #todo,这里应该是 所有site
    site.channels.each do |channel|
      channel.get_and_enqueue_links
      puts "[channel] process channel #{channel.url}"
    end
  end
end
