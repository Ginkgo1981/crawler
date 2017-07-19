namespace :channel do
  desc 'read from channel, then enqueue links '
  task :enqueue_links, [:site_id] => :environment do |t, args|
    puts "args: #{args}"
    site_id = args.site_id
    if site_id
      Channel.where(site_id: site_id).preload(:site).each do |channel|
        puts "[crawler] enqueue #{channel.site.name} 0 '#{channel.url}'"
        channel.enqueue_links
      end
    else
      Channel.all.preload(:site).each do |channel|
        puts "[crawler] enqueue #{channel.site.name} 0 '#{channel.url}'"
        channel.enqueue_links
      end
    end
  end

  desc 'read from redis, fetch the content then analyze the content'
  task dequeue: :environment do
    while(true)
      begin
        link_url = $redis.zrange('link_queue', 0, 0).first
        if link_url.present?
          $redis.zrem 'link_queue', link_url
          analyzer = Analyzer.factory(link_url)
          analyzer.get_content link_url
          puts "[crawler] dequeue link_url 0 '#{link_url}'"
        else
          puts "[crawler] dequeue empty 0 ''"
          sleep 10
        end
      rescue Exception => e
        puts "[crawler] dequeue error 0 ''"
      end
    end
  end


  desc 'clean_site_channel'
  task clean_all: :environment do
    sites= Site.delete_all
    channels = Channel.delete_all
    puts "[channel] clean 0 'sites:#{sites} | channels: #{channels}'"
  end


  desc 'create_all_channels'
  task create_all_channels: ['clean_all', 'job91:create_all', 'js_market:create_all'] do
    sites_count = Site.all.count
    channels_count = Channel.all.count
    puts "[crawler] create_channels all 0 'sites:#{sites_count} | channels: #{channels_count}'"
  end
end
