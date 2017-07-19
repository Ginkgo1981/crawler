namespace :job91 do

  desc 'create all 91job related website'
  task create_all: [:js_normal,:js_campus,:hb_normal,:hb_campus, :others_normal, :others_campus] do


  end

  desc 'js_normal'
  task js_normal: :environment do
    url = 'http://www.91job.gov.cn/default/schoollist'
    uri = URI url
    agent = Mechanize.new
    page = agent.get uri
    doc = Nokogiri::HTML(page.body)
    doc.css('.css-list li a').each do |u|
      if u['href'] =~ /http/
        site = Site.find_or_create_by! name: u.text, url: u['href']
        (1..10).each_with_index do |i|
          channel = Channel.create! site: site,
                                    name: "#{site.name}_p#{i}",
                                    status: 0,
                                    url: "http://#{URI(site.url).host}/job/search?d_category=100&page=#{i}"
          puts "[crawler] create_channels 91jobs_normal 0 '#{channel.name}'"
        end
      end
    end
  end

  desc 'js_campus'
  task js_campus: :environment do
    url = 'http://www.91job.gov.cn/default/schoollist'
    uri = URI url
    agent = Mechanize.new
    page = agent.get uri
    doc = Nokogiri::HTML(page.body)
    doc.css('.css-list li a').each do |u|
      site = Site.find_or_create_by! name: u.text, url: u['href']
      (1..10).each_with_index do |i|
        channel = Channel.create! site: site,
                                  name: "#{site.name}_p#{i}",
                                  status: 0,
                                  url: "http://#{URI(site.url).host}/campus/index?page=#{i}"
        puts "[crawler] create_channels 91jobs_normal 0 '#{channel.name}'"
      end
    end
  end



  #湖北 91job jobs
  desc 'hb_normal'
  task hb_normal: :environment do
    text=File.open('job_seeds/91_hbbys.txt').read
    text.each_line do |line|
      puts line
      url, name = line.split " "
      site = Site.find_or_create_by! name: name, url: url
      (1..10).each_with_index do |i|
        channel = Channel.create! site: site,
                                  name: "#{site.name}_p#{i}",
                                  status: 0,
                                  url: "http://#{URI(site.url).host}/job/search?d_category=100&page=#{i}"
        puts "[crawler] create_channels 91jobs_normal_hbbys 0 '#{channel.name}'"
      end
    end
  end

  #湖北 91job campus
  desc 'hb_campus'
  task hb_campus: :environment do
    text=File.open('job_seeds/91_hbbys.txt').read
    text.each_line do |line|
      puts line
      url, name = line.split " "
      site = Site.find_or_create_by! name: name, url: url
      (1..10).each_with_index do |i|
        channel = Channel.create! site: site,
                                  name: "#{site.name}_p#{i}",
                                  status: 1,
                                  url: "http://#{URI(site.url).host}/campus/index?page=#{i}"
        puts "[crawler] create_channels 91jobs_campus_hbbys 0 '#{channel.name}'"
      end
    end
  end


  #其它 91job jobs
  desc 'others_normal'
  task others_normal: :environment do
    text=File.open('job_seeds/91_others.txt').read
    text.each_line do |line|
      puts line
      name,url = line.split " "
      site = Site.find_or_create_by! name: name, url: url
      (1..10).each_with_index do |i|
        channel = Channel.create! site: site,
                                  name: "#{site.name}_p#{i}",
                                  status: 0,
                                  url: "http://#{URI(site.url).host}/job/search?d_category=100&page=#{i}"
        puts "[crawler] create_channels  others_normal 0 '#{channel.name}'"
      end
    end
  end



  #其它 91job jobs
  desc 'others_campus'
  task others_campus: :environment do
    text=File.open('job_seeds/91_others.txt').read
    text.each_line do |line|
      puts line
      name,url = line.split " "
      site = Site.find_or_create_by! name: name, url: url
      (1..10).each_with_index do |i|
        channel = Channel.create! site: site,
                                  name: "#{site.name}_p#{i}",
                                  status: 0,
                                  url: "http://#{URI(site.url)}/campus/index?page=#{i}"
        puts "[crawler] create_channels  others_campus 0 '#{channel.name}'"
      end
    end
  end
end
