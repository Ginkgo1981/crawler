class JsMarketWuxi< Analyzer

  def get_links(url = '')
    # url = 'http://www.wxrcw.com/more/hot'
    begin
      page = web_agent.get url
      doc = Nokogiri::HTML(page.body, nil)
      doc.css('.Membership_box a').map{|a| "http://www.wxrcw.com/#{a['href']}"}
    rescue Exception => e
      puts "[crawler] get_link #{self.class.to_s} 1 '#{e.to_s}'"
    end
  end

  def get_content(url = '')
    url = 'http://www.wxrcw.com/companyInfo.go?companyID=47f92c49-d074-4be3-ade6-f53bef85bb10&orderGuid='
    begin
      uri = URI url
      page = web_agent.get uri
      doc = Nokogiri::HTML(page.body)
      company_name = doc.css('#recruit_left1 h1').text rescue nil
      company_scale = doc.css('#recruit_left1 .subject')[0].text rescue nil
      company_kind = doc.css('#recruit_left1 .subject')[1].text rescue nil
      company_category = doc.css('#recruit_left1 .subject')[2].text rescue nil
      company_description = doc.css('.list8 div div')[0].text rescue nil
      company_email = doc.css('.list8 div div a')[0].text rescue nil
      company_json = {
          company_name: company_name,
          company_scale: company_scale,
          company_kind: company_kind,
          company_category: company_category,
          company_description: company_description,
          company_email: company_email
      }
      job_urls = doc.css('.search-result .table2 a').map{|a| "http://www.wxrcw.com/#{a['href']}"}.select{|l| l =~ /jobInfo/}
      job_urls.each do |job_url|
        job_page = web_agent.get job_url
        job_doc = Nokogiri::HTML(job_page.body)
        job_name = job_doc.css('.list8 table tr td')[0].text.split('：')[1] rescue nil
        job_category = job_doc.css('.list8 table tr td')[1].text.split('：')[1] rescue nil
        job_published_at = job_doc.css('.list8 table tr td')[4].text.split('：')[1] rescue nil
        job_mini_experience = job_doc.css('.list8 table tr td')[6].text.split('：')[1] rescue nil
        job_mini_education = job_doc.css('.list8 table tr td')[7].text.split('：')[1] rescue nil
        job_salary_range = job_doc.css('.list8 table tr td')[10].text.split('：')[1] rescue nil
        job_recruitment_num = job_doc.css('.list8 table tr td')[3].text.split('：')[1] rescue nil
        job_description = job_doc.css('.list8 table tr')[5].text.split('：')[1].strip rescue nil
        job_json = {
            job_name: job_name,
            job_category: job_category,
            job_published_at: job_published_at,
            job_mini_experience: job_mini_experience,
            job_mini_education: job_mini_education,
            job_salary_range: job_salary_range,
            job_recruitment_num: job_recruitment_num,
            job_description: job_description
        }
        json = job_json.merge(company_json)
        write_to_redis json, 'js_market_json_queue'
        puts "[crawler] get_content #{self.class.to_s} 0 '#{json.to_json}'"
      end
    rescue Exception => e
      puts "[crawler] get_content #{self.class.to_s} 1 '#{e.to_s}'"
    end
  end
end
