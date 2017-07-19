class JsMarketWujing < Analyzer

  def get_links(url = '')
    # url = 'http://www.wjjy.gov.cn/index.php?m=&c=jobs&a=jobs_list&p=1'
    begin
      page = web_agent.get url
      doc = Nokogiri::HTML(page.body, nil)
      doc.css('.td2 .line_substring').map{|a| "http://www.wjjy.gov.cn/#{a['href']}"}
    rescue Exception => e
      puts "[crawler] get_link #{self.class.to_s} 1 '#{e.to_s}'"
    end

  end

  def get_content(url = '')
    # url = 'http://www.wjjy.gov.cn/index.php?m=home&c=jobs&a=jobs_show&id=38009'
    login_url = 'http://www.wjjy.gov.cn/index.php?m=&c=members&a=login'
    begin
      web_driver = Selenium::WebDriver.for :remote, desired_capabilities: :phantomjs
      web_driver.navigate.to login_url
      web_driver.find_element(:name, 'username').send_keys('neo1981')
      web_driver.find_element(:name, 'password').send_keys('jian.chen')
      web_driver.find_element(:id,   'J_dologin').click
      web_driver.navigate.to url
      job_doc =  Nokogiri::HTML(web_driver.page_source)
      # #job
      job_name = job_doc.css('.jobstit .jobname').text.strip rescue nil
      job_type = job_doc.css('.itemli')[0].text.strip  rescue nil
      job_published_at = job_doc.css('.timebg')[0].text.strip rescue nil
      job_salary_range = job_doc.css('.jobstit .wage').text.strip rescue nil
      job_benefits = job_doc.css('.lab .li').map(&:text)
      job_mini_education = job_doc.css('.itemli')[3].text.strip rescue nil
      job_recruitment_num = job_doc.css('.itemli')[2].text.strip rescue nil
      job_mini_experience = job_doc.css('.itemli')[4].text.strip rescue nil
      job_city = job_doc.css('.add').text
      job_description = job_doc.css('.describe .txt').text.strip rescue nil
      # #company
      company_name = job_doc.css('.comname a').text.strip rescue nil
      company_origin_url =  "http://www.wjjy.gov.cn/#{job_doc.css('.comname a')[0]['href']}" rescue nil
      web_driver.navigate.to company_origin_url
      company_doc =  Nokogiri::HTML(web_driver.page_source)
      company_website = company_doc.css('.fl.content_c a')[0]['href'] rescue nil
      company_mobile = company_doc.css('.txt .fl:not(.txt_t)')[1].text rescue nil
      company_tel = company_doc.css('.txt .fl:not(.txt_t)')[2].text rescue nil
      company_address = company_doc.css('.txt .fl:not(.txt_t)')[3].text  rescue nil
      # company_email = company_doc.css('.txt .fl:not(.txt_t)')[2].text  rescue nil
      company_description = company_doc.css('.infobox .txt').text rescue nil
      # web_driver.save_screenshot('aaa.png')
      json = {
          job_name: job_name,
          job_benefits: job_benefits,
          job_recruitment_num: job_recruitment_num,
          job_published_at: job_published_at,
          job_salary_range: job_salary_range,
          job_type: job_type,
          job_city: job_city,
          job_mini_education: job_mini_education,
          job_mini_experience: job_mini_experience,
          job_description: job_description,
          job_origin_url: url,
          company_name: company_name,
          company_address: company_address,
          company_description: company_description,
          company_origin_url: company_origin_url,
          company_website:company_website,
          company_mobile:company_mobile,
          company_tel: company_tel
          # company_email: company_email
      }
      write_to_redis json, 'js_market_json_queue'
      puts "[crawler] get_content #{self.class.to_s}  0 '#{json.to_json}'"
    rescue Exception => e
      puts "[crawler] get_content #{self.class.to_s} 1 '#{e.to_s}'"
    end
  end
end
