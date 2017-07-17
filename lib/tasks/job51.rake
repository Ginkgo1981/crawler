namespace :job51 do
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
end
