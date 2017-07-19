class JsMarketZhengjiang < Analyzer

  def get_links(url = '')
    # url = 'http://www.hrol.cn/jobs/jobs-list.php?sort=rtime&page=1'
    begin
      page = web_agent.get url
      doc = Nokogiri::HTML(page.body, nil)
      doc.css('.jobname a').map{|a| "http://www.hrol.cn/#{a['href']}"}
    rescue Exception => e
      puts "[crawler] get_link #{self.class.to_s} 1 '#{e.to_s}' #{url}"
    end

  end

  def get_content(url = '')
     # url = 'http://www.hrol.cn/jobs/jobs-show.php?id=48175'
    login_url = 'http://www.hrol.cn/user/login.php'
    begin
      web_driver = Selenium::WebDriver.for :remote, desired_capabilities: :phantomjs
      web_driver.navigate.to login_url
      web_driver.find_element(:name, 'username').clear()
      web_driver.find_element(:name, 'username').send_keys('dada2017')
      web_driver.find_element(:name, 'password').send_keys('dada2017')
      web_driver.find_element(:id,   'login').click
      web_driver.navigate.to url
      job_doc =  Nokogiri::HTML(web_driver.page_source)
      # #job
      job_name = job_doc.css('.jobsshow h1').text.strip rescue nil
      job_type =  job_doc.css('.link_bku li')[2].text.split('：')[1] rescue nil
      job_salary_range = job_doc.css('.link_bku li')[3].text.split('：')[1] rescue nil
      job_recruitment_num = job_doc.css('.link_bku li')[4].text.split('：')[1] rescue nil
      job_mini_education = job_doc.css('.link_bku li')[6].text.split('：')[1] rescue nil
      job_city = job_doc.css('.link_bku li')[7].text.split('：')[1] rescue nil
      job_category = job_doc.css('.link_bku li')[8].text.split('：')[1] rescue nil
      job_mini_experience =  job_doc.css('.link_bku li')[9].text.split('：')[1] rescue nil
      job_published_at = job_doc.css('.link_bku li')[12].text.split('：')[1].split(' ')[0] rescue nil
      job_tags = job_doc.css('.link_bku li')[14].text.split('：')[1].split(' ') rescue nil
      job_description = job_doc.css('.jobsshow').text.split('工作职责：')[1].split('联系方式')[0].strip rescue nil

      company_name = job_doc.css('.link_bku li a')[0].text rescue nil
      company_origin_url = "http://www.hrol.cn/#{job_doc.css('.link_bku li a')[0]['href']}" rescue nil
      company_hr_name = job_doc.css('#jobs_contact li')[0].text.split('：')[1] rescue nil
      company_tel =  job_doc.css('#jobs_contact li')[1].text.split('：')[1] rescue nil
      company_email = job_doc.css('#jobs_contact li')[2].text.split('：')[1] rescue nil
      company_address =  job_doc.css('#jobs_contact li')[3].text.split('：')[1] rescue nil
      #company doc
      company_page = web_agent.get company_origin_url
      company_doc = Nokogiri::HTML(company_page.body, nil)
      company_description = company_doc.css('.show').text.split('公司简介')[1].strip rescue nil
      json = {
          job_name: job_name,
          job_category: job_category,
          job_recruitment_num: job_recruitment_num,
          job_published_at: job_published_at,
          job_salary_range: job_salary_range,
          job_type: job_type,
          job_city: job_city,
          job_tags: job_tags,
          job_mini_education: job_mini_education,
          job_mini_experience: job_mini_experience,
          job_description: job_description,
          job_origin_url: url,
          company_name: company_name,
          company_hr_name: company_hr_name,
          company_address: company_address,
          company_description: company_description,
          company_origin_url: company_origin_url,
          company_tel: company_tel,
          company_email: company_email
      }
      write_to_redis json, 'js_market_json_queue'
      puts "[crawler] get_content #{self.class.to_s} 0 '#{json.to_json}' '#{url}'"
    rescue Exception => e
      puts "[crawler] get_content #{self.class.to_s} 1 '#{e.to_s}' '#{url}'"
    end
  end
end
