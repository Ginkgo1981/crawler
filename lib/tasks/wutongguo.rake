namespace :wutongguo do
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
end
