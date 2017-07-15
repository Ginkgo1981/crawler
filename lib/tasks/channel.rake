namespace :channel do
  desc 'read from channel, then enqueue links '
  task :enqueue_links, [:site_id] => :environment do |t, args|
    puts "args: #{args}"
    site_id = args.site_id
    if site_id
      Channel.where(site_id: 458).preload(:site).each do |channel|
        puts "[channel] process channel 0 '#{channel.url}'"
        channel.enqueue_links
      end
    else
      Channel.all.preload(:site).each do |channel|
        puts "[channel] process channel 0 '#{channel.url}'"
        channel.enqueue_links
      end
    end
  end

  desc 'create_channels_91jobs_normal'
  task create_channels_91jobs_normal: :environment do
    url = 'http://www.91job.gov.cn/default/schoollist'
    uri = URI url
    agent = Mechanize.new
    page = agent.get uri
    doc = Nokogiri::HTML(page.body)
    doc.css('.css-list li a').each do |u|
      site = Site.find_or_create_by! name: u.text, url: u['href']
      (1..10).each_with_index do |i|
        channel = Channel.create! site: site,
                                  name: "#{site.name}-p#{i}",
                                  status: 1,
                                  url: "#{site.url}/job/search?d_category=100&page=#{i}"
        puts "[channel] create-channels 91jobs_normal 0 '#{channel.name}'"
      end
    end
  end

  desc 'create_channels_91jobs_campus'
  task create_channels_91jobs_campus: :environment do
    url = 'http://www.91job.gov.cn/default/schoollist'
    uri = URI url
    agent = Mechanize.new
    page = agent.get uri
    doc = Nokogiri::HTML(page.body)
    doc.css('.css-list li a').each do |u|
      site = Site.find_or_create_by! name: u.text, url: u['href']
      (1..10).each_with_index do |i|
        channel = Channel.create! site: site,
                                  name: "#{site.name}-p#{i}",
                                  status: 1,
                                  url: "#{site.url}/campus/index?page=#{i}"
        puts "[channel] create-channels 91jobs_normal 0 '#{channel.name}'"
      end
    end
  end


  desc 'create_channels_51jobs'
  task create_channels_51jobs: :environment do
    site = Site.create! name: '51job', url: 'http://www.51job.com'
    ['nanjing'].each do |city|
      (1..2).each_with_index do |i|
        channel = Channel.create! site: site,
                                  name: "#{site.name}-p#{i}",
                                  status: 1,
                                  url: "http://jobs.51job.com/nanjing/p#{i}"
      end
    end
  end




  desc 'create_channels_wutongguo'
  task create_channels_wutongguo: :environment do
    site = Site.create! name: '梧桐果', url: 'http://www.wutongguo.com'
    (1..100).each_with_index do |i|
      channel = Channel.create! site: site,
                                name: "#{site.name}-p#{i}",
                                status: 1,
                                url: "#{site.url}/wangshen/n#{i}"
      puts "[channel] create-channels Wutongguo 0 '#{channel.name}'"
    end
  end



  desc 'create_channels_js_market_wujing'
  task create_channels_js_market_wujing: :environment do
    site = Site.create! name: '武进人才网', url: 'http://www.wjjy.gov.cn'
    (1..10).each_with_index do |i|
      channel = Channel.create! site: site,
                                name: "#{site.name}-p#{i}",
                                status: 1,
                                url: "#{site.url}/index.php?m=&c=jobs&a=jobs_list&education=70&p=#{i}"
      puts "[channel] create-channels js_market_wujing 0 '#{channel.name}'"
    end
  end



  desc 'clean_site_channel'
  task clean_site_channel: :environment do
    Site.delete_all
    Channel.delete_all
    puts "[channel] delete-all 0 ''"
  end


  desc 'create_all_channels'
  task create_all_channels: [:clean_site_channel, :create_channels_91jobs, :create_channels_wutongguo] do
    puts "[channel] create-channels all 0 'succ'"
  end
end
