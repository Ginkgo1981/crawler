namespace :channel do
  desc 'read from channel, then enqueue links '
  task enqueue_links: :environment do
    Channel.all.include(:site).each do |channel|
      puts "[channel] process channel 0 '#{channel.url}'"
      channel.enqueue_links
    end
  end

  desc 'create_channels_91jobs'
  task create_channels_91jobs: :environment do
    url = 'http://www.91job.gov.cn/default/schoollist'
    uri = URI url
    agent = Mechanize.new
    page = agent.get uri
    doc = Nokogiri::HTML(page.body)
    doc.css('.css-list li a').each do |u|
      site = Site.create! name: u.text, url: u['href']
      (1..10).each_with_index do |i|
        channel = Channel.create! site: site,
                                  name: "#{site.name}-p#{i}",
                                  status: 1,
                                  url: "#{site.url}/job/search?d_category=100&page=#{i}",
                                  analyzer: 'Js91job'
        puts "[channel] create-channels 91jobs 0 '#{channel.name}'"
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
                                url: "#{site.url}/wangshen/n#{i}",
                                analyzer: 'Wutongguo'
      puts "[channel] create-channels Wutongguo 0 '#{channel.name}'"
    end
  end

  desc 'create_channels_wutongguo'
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
