namespace :channel do
  desc 'enqueue channels' # run at loop
  task enqueue_channels: :environment do
    Channel.joins(:site).where("sites.status=1").preload(:site).each do |channel|
      puts "#{channel.name} #{channel.url}"
      $redis.sadd 'enqueued_channels', "#{channel.name} #{channel.url}"
    end
  end

  desc 'enqueue links' #stand alone
  task enqueue_links: :environment do
    while true
      begin
        c = $redis.spop 'enqueued_channels'
        if c
          name, url = c.split /\s/
          Channel.enqueue_links name, url
          puts "[crawler] enqueue succ 0 '#{name}' '#{url}'"
        else
          puts "[crawler] enqueue finish 0 '#{Time.now.to_s}' ''"
          sleep 10*60
        end
      rescue Exception => e
        puts "[crawler] enqueue error 0 '#{e.to_s}' ''"
        sleep 1*60
      end
    end
  end

  desc 'read from redis, fetch the content then analyze the content' #stand alone
  task dequeue: :environment do
    while (true)
      begin
        link_url = $redis.zrange('enqueued_links', 0, 0).first
        if link_url.present?
          $redis.zrem 'enqueued_links', link_url
          analyzer = Analyzer.factory(link_url)
          analyzer.get_content link_url
          puts "[crawler] dequeue succ 0 '' '#{link_url}'"
        else
          puts "[crawler] dequeue fail 0 'empty' ''"
          sleep 10
        end
      rescue Exception => e
        puts "[crawler] dequeue fail 0 '#{e.to_s}' '#{link_url}'"
      end
    end
  end


  desc 'clean_site_channel'
  task clean: :environment do
    sites= Site.delete_all
    channels = Channel.delete_all
    puts "[channel] clean 0 'sites:#{sites} | channels: #{channels}'"
  end


  desc 'create_all_channels'
  task create: %w(job91:all job51:all js_market:all wutongguo:all) do
    sites_count = Site.all.count
    channels_count = Channel.all.count
    puts "[crawler] create_channels all 0 'sites:#{sites_count} | channels: #{channels_count}'"
  end
end
