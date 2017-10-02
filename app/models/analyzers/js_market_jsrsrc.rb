class JsMarketJsrsrc < Analyzer

  #说明
  #江苏省人才需要 验证码接口,不进 link queue, 一定登录后抓取所有信息
  def start
    login
    (0..1).each_with_index do |i|
      sleep 1
      url = "http://www.jsrsrc.com/jobs/jobs-list.php?sort=rtime&page=#{i}"
      puts "[crawler] enqueue_links #{self.class.to_s} 0 '' '#{url}'"
      self.get_links url
    end
  end

  def login
    login_url = 'http://www.jsrsrc.com/user/login.php'
    web_driver.navigate.to login_url
    login_doc = Nokogiri::HTML(web_driver.page_source)
    captcha_url = 'http://www.jsrsrc.com' + login_doc.css('#identify_img')[0]['src']
    captcha = get_captcha(captcha_url)
    #login
    web_driver.find_element(:name, 'username').clear()
    web_driver.find_element(:name, 'username').send_keys('neo1981')
    web_driver.find_element(:name, 'password').send_keys('jian.chen')
    web_driver.find_element(:id, 'identify').send_keys(captcha)
    web_driver.find_element(:id, 'submit_login').click
  end


  def get_links(url = '')
    # url = 'http://www.jsrsrc.com/jobs/jobs-list.php?sort=rtime&page=1'
    begin
      # web_driver = Selenium::WebDriver.for :remote, desired_capabilities: :phantomjs
      web_driver.navigate.to url
      doc =  Nokogiri::HTML(web_driver.page_source)
      if doc.css('#top_loginform').text =~ /neo/
        puts "[crawler] login #{self.class.to_s} 0 '#{url}'"
      else
        puts "[crawler] login #{self.class.to_s} 1 '#{url}'"
      end
      link_urls = doc.css('.jobs_name a').map{|a| "#{a['href']}"}
      link_urls.each do |url|
        self.get_content url
        puts "[crawler] enqueue_links #{self.class.to_s} 0 '' '#{url}'"
      end

    rescue Exception => e
      puts "[crawler] get_link #{self.class.to_s} 1 '#{e.to_s}' '#{url}'"
    end

  end

  def get_content(url = '')
    # url = 'http://www.jsrsrc.com/jobs/jobs-show.php?id=533510'
    begin
      # web_driver = Selenium::WebDriver.for :remote, desired_capabilities: :phantomjs
      #captcha
      web_driver.navigate.to url
      sleep 2
      job_doc =  Nokogiri::HTML(web_driver.page_source)
      # #job
      job_name = job_doc.css('.de_tit h3').text rescue nil
      job_recruitment_num = job_doc.css('.detail_info .w248')[0].text.split('：')[1] rescue nil
      job_salary_range = job_doc.css('.detail_info li span').text rescue nil
      job_category = job_doc.css('.detail_info .w248')[1].text.split('：')[1] rescue nil
      job_mini_education = job_doc.css('.detail_info .w248')[3].text.split('：')[1] rescue nil
      job_mini_experience = job_doc.css('.detail_info ul li:nth-of-type(3) div:nth-of-type(3)').text.split('：')[1] rescue nil
      job_city = job_doc.css('.detail_info ul li:nth-of-type(4)').text.split('：')[1].strip rescue nil
      job_description = job_doc.css('.des').text.strip rescue nil
      job_published_at = job_doc.css('.data').text.split('：')[1] rescue nil

      job_json = {
          job_name: job_name,
          job_category: job_category,
          job_recruitment_num: job_recruitment_num,
          job_published_at: job_published_at,
          job_salary_range: job_salary_range,
          job_city: job_city,
          job_mini_education: job_mini_education,
          job_mini_experience: job_mini_experience,
          job_description: job_description,
          job_origin_url: url
      }

      #company
      company_name = job_doc.css('.name a').text rescue nil
      company_origin_url = job_doc.css('.name a')[0]['href'] rescue nil
      company_category = job_doc.css('.info_txt p')[1].text.split('：')[1] rescue nil
      company_scale = job_doc.css('.info_txt p')[2].text.split('：')[1] rescue nil
      company_website =  job_doc.css('.info_txt p')[3].text.split('：')[1] rescue nil
      company_hr_name = job_doc.css('.contact_con p')[0].text.split('：')[1] rescue nil
      company_email = job_doc.css('.contact_con p')[2].text.split('：')[1] rescue nil
      company_mobile = job_doc.css('.contact_con p')[1].text.split('：')[1] rescue nil

      #company doc
      web_driver.navigate.to company_origin_url
      company_doc =  Nokogiri::HTML(web_driver.page_source)
      company_description = company_doc.css('.com_container p:nth-of-type(1)').text rescue nil
      company_address = company_doc.css('.title_txt p').text rescue nil

      company_json = {
          company_name: company_name,
          company_hr_name:  company_hr_name,
          company_scale: company_scale,
          company_category: company_category,
          comapny_website: company_website,
          company_mobile: company_mobile,
          company_address: company_address,
          company_description: company_description,
          company_origin_url: company_origin_url,
          company_email: company_email
      }

      json = job_json.merge(company_json)
      write_to_redis json, 'company_job_json_queue'
      puts "[crawler] get_content #{self.class.to_s} 0 '#{json.to_json}' '#{url}'"
    rescue Exception => e
      puts "[crawler] get_content #{self.class.to_s} 1 '#{e.to_s}' '#{url}'"
    end
  end
end
