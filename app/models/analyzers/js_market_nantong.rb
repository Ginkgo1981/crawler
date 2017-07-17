class JsMarketNantong < Analyzer

  def get_links(url = '')
    # url = 'http://www.ntr.com.cn/jobs/jobs_list/sort/rtime/page/1.html'
    begin
      page = web_agent.get url
      doc = Nokogiri::HTML(page.body, nil)
      doc.css('.td-j-name a').map{|a| "#{a['href']}"}
    rescue Exception => e
      puts "[crawler] get_link #{self.class.to_s} 1 '#{e.to_s}'"
    end

  end

  def get_content(url = '')
    # url = 'http://www.ntr.com.cn/jobs/60208510.html'
    login_url = 'http://www.ntr.com.cn/members/login.html'
    begin
      web_driver = Selenium::WebDriver.for :remote, desired_capabilities: :phantomjs
      web_driver.navigate.to login_url
      web_driver.find_element(:name, 'username').clear()
      web_driver.find_element(:name, 'username').send_keys('dada2017')
      web_driver.find_element(:name, 'password').send_keys('dada2017')
      web_driver.find_element(:id,   'J_dologin').click
      web_driver.navigate.to url
      job_doc =  Nokogiri::HTML(web_driver.page_source)
      # #job
      job_name = job_doc.css('.j-n-txt').text.strip rescue nil
      job_salary_range = job_doc.css('.jobstit .wage').text rescue nil
      job_type = job_doc.css('div.itemli')[0].text rescue nil
      job_category = job_doc.css('div.itemli')[1].text rescue nil
      job_recruitment_num = job_doc.css('div.itemli')[2].text rescue nil
      job_mini_education = job_doc.css('div.itemli')[3].text rescue nil
      job_mini_experience = job_doc.css('div.itemli')[4].text rescue nil
      job_city = job_doc.css('.add').text rescue nil
      job_published_at = job_doc.css('.timebg')[0].text.strip rescue nil
      job_description = job_doc.css('.describe .txt')&.text.strip

      company_name = job_doc.css('.comname a').text.strip rescue nil
      company_origin_url =  "#{job_doc.css('.comname a')[0]['href']}" rescue nil
      web_driver.navigate.to company_origin_url

      #company_doc
      company_doc =  Nokogiri::HTML(web_driver.page_source)
      company_mobile = company_doc.css('.txt .fl:not(.txt_t)')[0].text rescue nil
      company_tel = company_doc.css('.txt .fl:not(.txt_t)')[1].text rescue nil
      company_address = company_doc.css('.txt .fl:not(.txt_t)')[3].text  rescue nil
      company_email = company_doc.css('.line_substring').text rescue nil
      company_description = company_doc.css('.infobox .txt').text rescue nil

      json = {
          job_name: job_name,
          job_category: job_category,
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
          company_mobile: company_mobile,
          company_address: company_address,
          company_description: company_description,
          company_origin_url: company_origin_url,
          company_tel: company_tel,
          company_email: company_email
      }
      write_to_redis json, 'company_job_json_queue'
      puts "[crawler] get_content #{self.class.to_s} 0 '#{json.to_json}'"
    rescue Exception => e
      puts "[crawler] get_content #{self.class.to_s} 1 '#{e.to_s}''"
    end
  end
end
