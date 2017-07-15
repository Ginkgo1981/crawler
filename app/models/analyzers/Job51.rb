class Job51 < Analyzer

  def initialize
    @@driver = Selenium::WebDriver.for :remote, desired_capabilities: :phantomjs
  end

  def get_driver
    if @@driver && @@driver.session_id
    else
      @@driver = Selenium::WebDriver.for :remote, desired_capabilities: :phantomjs
    end
    @@driver
  end


  def get_links(url = '')
    # url = 'http://jobs.51job.com/nanjing/p1'
    begin
      get_driver.get url
      doc =  Nokogiri::HTML(get_driver.page_source)
      doc.css('.info .title a').map{|a| a['href']}
    rescue Exception => e
      puts "[analyzer] get_51job_links error 0 '#{e.to_s}'"
    end

  end

  def get_content(url = '')
    # url = 'http://jobs.51job.com/nanjing-xwq/86226770.html?s=02'
    begin
      get_driver.get url
      doc =  Nokogiri::HTML(get_driver.page_source)

      #company
      company_name = doc.css('.cname a')&.text&.strip
      company_url =  doc.css('.cname a')[0]['href']
      company_kind,company_scale, company_category = doc.css('.ltype').text.split(/\|/).map(&:strip)
      company_description = doc.css('.tmsg.inbox')&.text&.strip
      company_address = doc.css('.tBorderTop_box .bmsg .fp')&.text&.split('上班地址：')&.first&.strip

      #job
      job_name = doc.css('.in .cn h1')&.text&.strip
      job_city = doc.css('.lname')&.text&.strip
      job_mini_experience = doc.css('.sp4:has(.i1)')&.text&.strip
      job_mini_education = doc.css('.sp4:has(.i2)').text&.strip
      job_recruitment_num = doc.css('.sp4:has(.i3)')&.text&.strip
      job_published_at = doc.css('.sp4:has(.i4)')&.text&.strip
      #todo i5
      job_majors = doc.css('.sp2:has(.i6)')&.text&.strip.split(" ")
      job_description = doc.css('.job_msg')&.text&.strip
      job_benefits = doc.css('.t2 span').map{|l| l&.text&.strip}
      job_category = doc.css('.fp .el').first&.text&.strip
      json = {
          job_name: job_name,
          job_majors: job_majors,
          job_benefits: job_benefits,
          job_recruitment_num: job_recruitment_num,
          job_published_at: job_published_at,
          job_type: '全职',
          job_category: job_category,
          job_city: job_city,
          job_mini_education: job_mini_education,
          job_mini_experience: job_mini_experience,
          job_description: job_description,
          company_name: company_name,
          company_category: company_category,
          company_kind: company_kind,
          company_scale: company_scale,
          company_address: company_address,
          company_description: company_description,
          company_url: company_url
      }
      write_to_redis json, '51job'
      puts "[analyzer] get_51job_links succ 0 '#{json.to_json}'"
    rescue Exception => e
      puts "[analyzer] get_51job_links error 0 '#{e.to_s}'"
    end
  end
end
