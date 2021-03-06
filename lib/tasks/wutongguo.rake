namespace :wutongguo do
  desc 'all'
  task all: :environment do
    site = Site.create! name: '梧桐果', url: 'http://www.wutongguo.com'
    (1..100).each_with_index do |i|
      channel = Channel.create! site: site,
                                name: "#{site.name}_p#{i}",
                                status: 0,
                                url: "#{site.url}/wangshen/n#{i}"
      puts "[crawler] create_channels succ 0 '#{channel.name}' '#{channel.url}'"
    end
  end
end
