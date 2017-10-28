namespace :channel do
  desc 'enqueue channels' # run at loop
  task enqueue_channels: :environment do
    SlackService.alert "[crawler] enqueue_channels started"
    count = 0
    Channel.joins(:site).where("sites.status=1").preload(:site).each do |channel|
      puts "#{channel.name} #{channel.url}"
      count += 1
      $redis.rpush 'enqueued_channels_list', "#{channel.name} #{channel.url}"
    end
    SlackService.alert "[crawler] enqueue_channels end #{count}"
  end

  desc 'enqueue links' #stand alone
  task enqueue_links: :environment do
    SlackService.alert "[crawler] enqueue_links started"
    flag = true
    count  = 0
    while flag
      begin
        c = $redis.lpop 'enqueued_channels_list'
        count += 1
        SlackService.alert "[crawler] enqueue_links processing #{count}"  if count % 2000 == 0
        if c
          name, url = c.strip.split /\s/
          Channel.enqueue_links name, url
          puts "[crawler] enqueue_links succ 0 '#{name}' '#{url}'"
        else
          flag = false
          puts "[crawler] enqueue_links finish 0 '#{Time.now.to_s}' ''"
        end
      rescue Exception => e
        SlackService.alert "[crawler] enqueue_links error #{count} #{c} #{e.to_s}"  if count % 3 == 0
        puts "[crawler] enqueue_links error 0 '#{e.to_s}' '#{c}'"
      end
    end
    SlackService.alert "[crawler] enqueue_links ended #{count}"
  end

  desc 'read from redis, fetch the content then analyze the content' #stand alone
  task fetch_and_enqueue_company_job_json: :environment do
    SlackService.alert "[crawler] fetch_and_enqueue_company_job_json started"
    flag = true
    count  = 0
    while flag
      begin
        link_url = $redis.lpop 'enqueued_links_list'
        count += 1
        SlackService.alert "[crawler] fetch_and_enqueue_company_job_json processing #{count}"  if count % 1000 == 0
        # link_url = $redis.zrange('enqueued_links', 0, 0).first
        if link_url.present?
          # $redis.zrem 'enqueued_links', link_url
          analyzer = Analyzer.factory(link_url)
          json = analyzer.get_content link_url
          if json.is_a? Array
            json.each { |j| analyzer.write_to_redis j }
          else
            analyzer.write_to_redis json
          end
          puts "[crawler] dequeue succ 0 '' '#{link_url}'"
        else
          flag = false
          puts "[crawler] dequeue fail 0 'empty' '#{Time.now.to_s}'"
          # sleep 10
        end
      rescue Exception => e
        SlackService.alert "[crawler] fetch_and_enqueue_company_job_json error #{count} #{link_url} #{e.to_s}"  if count % 3 == 0
        puts "[crawler] dequeue fail 0 '#{e.to_s}' '#{link_url}'"
      end
    end
    SlackService.alert "[crawler] fetch_and_enqueue_company_job_json ended #{count}"
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
