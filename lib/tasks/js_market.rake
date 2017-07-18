namespace :js_market do
  desc '武进' #武进
  task wj: :environment do
    site = Site.create! name: '武进人才网', url: 'http://www.wjjy.gov.cn'
    (1..10).each_with_index do |i|
      channel = Channel.create! site: site,
                                name: "#{site.name}-p#{i}",
                                status: 1,
                                url: "#{site.url}/index.php?m=&c=jobs&a=jobs_list&education=70&p=#{i}"
      puts "[channel] create-channels js_market_wujing 0 '#{channel.name}'"
    end
  end


  desc '无锡' #无锡
  task wx: :environment do
    site = Site.create! name: '武进人才网', url: 'http://www.wxrcw.com'
    Channel.create! site: site,
                              name: "#{site.name}",
                              status: 1,
                              url: 'http://www.wxrcw.com/more/hot'
  end


  desc '镇江' #
  task zj: :environment do
    site = Site.create! name: '镇江人才网', url: 'http://www.hrol.cn'
    (1..10).each_with_index do |i|
      Channel.create! site: site,
                      name: "#{site.name}",
                      status: 1,
                      url: "http://www.hrol.cn/jobs/jobs-list.php?sort=rtime&page=#{i}"
    end
  end

  desc '南通' #
  task nt: :environment do
    site = Site.create! name: '江海人才网(南通)', url: 'http://www.ntr.com.cn'
    (1..10).each_with_index do |i|
      Channel.create! site: site,
                      name: "#{site.name}",
                      status: 1,
                      url: "http://www.ntr.com.cn/jobs/jobs_list/sort/rtime/page/#{i}.html"
    end
  end

  desc '扬州' #
  task yz: :environment do
    site = Site.create! name: '扬州人才网', url: 'http://www.yzjob.net.cn'
    (1..10).each_with_index do |i|
      Channel.create! site: site,
                      name: "#{site.name}",
                      status: 1,
                      url: "http://www.yzjob.net.cn/job_list.shtml?postType=&workPlace=&dayNum=&unitName=&postName=&curPage=#{i}"
    end
  end


end
