class JsMarketYangzhou< Analyzer

  def get_links(url = '')
    # url = 'http://www.yzjob.net.cn/job_list.shtml?postType=&workPlace=&dayNum=&unitName=&postName=&curPage=1'
    begin
      page = web_agent.get url
      doc = Nokogiri::HTML(page.body, nil)
      doc.css('.List1').map { |d| 'http://www.yzjob.net.cn/' + d.css('.TD1 a')[0]['href']+'&time='+d.css('.TD2').text.split(' ')[0] }
    rescue Exception => e
      puts "[crawler] get_link #{self.class.to_s} 1 '#{e.to_s}'"
    end
  end

  def get_content(url = '')
    # url = 'http://www.yzjob.net.cn/job_info.shtml?code=4CF921996C0BCD7CE050A8C0C7911969&time=2017-07-18'
    begin
      uri = URI url
      job_page = web_agent.get uri
      job_doc = Nokogiri::HTML(job_page.body)
      job_published_at = url.split('=')[2] rescue nil
      job_name = job_doc.at('#postName').values[2] rescue nil
      job_mini_education = job_doc.css('.List2 .TD2').text.split(':')[1] rescue nil
      job_mini_experience = job_doc.css('.List2 .TD5').text.split(' ')[1] rescue nil
      job_city = job_doc.css('.List2 .TD6').text.split(' ')[1] rescue nil
      job_description = job_doc.css('.job_info_right li')[3].text.strip rescue nil
      job_category = job_doc.css('.job_info_left li')[0].text.split(':')[1].strip rescue nil
      job_recruitment_num = job_doc.css('.job_info_left li')[1].text.split(':')[1].strip rescue nil
      job_salary_range = job_doc.css('.job_info_left li')[2].text.split(' ')[1] rescue nil
      company_origin_url = "http://www.yzjob.net.cn/#{job_doc.css('.List2 .TD3 a')[0]['href']}" rescue nil
      job_json = {
          job_name: job_name,
          job_category: job_category,
          job_published_at: job_published_at,
          job_mini_experience: job_mini_experience,
          job_mini_education: job_mini_education,
          job_salary_range: job_salary_range,
          job_recruitment_num: job_recruitment_num,
          job_description: job_description,
          job_city: job_city
      }
      #company
      company_page = web_agent.get company_origin_url
      company_doc = Nokogiri::HTML(company_page.body)
      company_name = company_doc.css('.title_txt h2').text.strip rescue nil
      company_address = company_doc.css('.title_txt p').text rescue nil
      company_description = company_doc.css('.com_txt p').text.strip rescue nil
      company_scale = company_doc.css('.right_box .list li')[2].text.split('：')[1] rescue nil
      company_hr_name = company_doc.css('#company_contact li')[0].text.split('：')[1] rescue nil
      company_mobile = company_doc.css('#company_contact li')[1].text.split('：')[1] rescue nil
      company_tel = company_doc.css('#company_contact li')[3].text.split('：')[1] rescue nil

      company_json = {
          company_name: company_name,
          company_address: company_address,
          company_scale: company_scale,
          company_description: company_description,
          company_hr_name: company_hr_name,
          company_mobile: company_mobile,
          company_tel: company_tel
      }
      json = job_json.merge(company_json)
      write_to_redis json, 'js_market_json_queue'
      puts "[crawler] get_content #{self.class.to_s} 0 '#{json.to_json}'"
    rescue Exception => e
      puts "[crawler] get_content #{self.class.to_s} 1 '#{e.to_s}'"
    end
  end
end
