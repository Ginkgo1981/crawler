namespace :job51 do
  desc 'all'
  task all: :environment do
    site = Site.create! name: '51job', url: 'http://www.51job.com', status: 0
    ['nanjing'].each do |city|
      (1..2).each_with_index do |i|
        Channel.create! site: site,
                                  name: "#{site.name}_p#{i}",
                                  status: 0,
                                  url: "http://jobs.51job.com/nanjing/p#{i}"
      end
    end
  end
end
