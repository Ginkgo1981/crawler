namespace :channel do
  desc 'read from mysql, then enqueue links '
  task :enqueue, [:site_id] => :environment do |t, args|
    puts "args: #{args}"
    site_id = args.site_id
    if site_id
      Channel.where(site_id: site_id).preload(:site).each do |channel|
        puts "[crawler] enqueue succ 0 '#{channel.site.name}' '#{channel.url}'"
        channel.enqueue_links
      end
    else
      count = 0
      # while(true)
        begin
          count = $redis.zcount 'link_queue', "-inf", "+inf"
          puts "[crawler] enqueue try #{count} '' ''"
          if count < 1000
            # puts "[crawler] enqueue begin #{count} '' ''"
            Channel.joins(:site).where("sites.status=1").preload(:site).each do |channel|
              begin
                puts "[crawler] enqueue succ 0 '#{channel.site.name}' '#{channel.url}'"
                channel.enqueue_links
              rescue Exception => e
                puts "[crawler] enqueue fail 0 '#{channel.site.name}: #{e.to_s}' '#{channel.url}'"
              end
            end
            puts "[crawler] enqueue finish 0 '#{Time.now.to_s}' ''"
          end
        rescue Exception => e
          sleep 10*60
          puts "[crawler] enqueue error 0 '#{e.to_s}' ''"
        end
      # end
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
  task create:  %w(job91:all job51:all js_market:all wutongguo:all) do
    sites_count = Site.all.count
    channels_count = Channel.all.count
    puts "[crawler] create_channels all 0 'sites:#{sites_count} | channels: #{channels_count}'"
  end
end
