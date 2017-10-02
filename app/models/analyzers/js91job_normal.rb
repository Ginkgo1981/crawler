class Js91jobNormal < Analyzer

  def get_links(url)
    begin
      uri = URI url
      # agent = Mechanize.new
      page = web_agent.get uri
      doc = Nokogiri::HTML(page.body)
      host = uri.host
      links = doc.css('.infoList .span1 a').map{|a| "http://#{host}#{a['href']}" }
    rescue Exception => e
      puts "[crawler] get_links #{self.class.to_s} 1 '#{e.to_s}' '#{url}'"
    end
  end

  def get_content(url = '')
    # url = 'http://njfu.91job.gov.cn/job/view/id/1317315'
    begin
      uri = URI url
      # agent = Mechanize.new
      job_page = web_agent.get uri
      job_doc = Nokogiri::HTML(job_page.body)
      job_name = job_doc.css('.viewHead h1').text
      job_items = job_doc.css('.xInfo-2 span').map{|item| item.text}
      job_salary_range, job_recruitment_num, job_published_at, job_type, job_category,
          job_city, job_mini_education, job_mini_experience,job_language,company_email = job_items
      job_description = job_doc.css('.vContent.cl').text.try(:strip)
      #company detail page url
      company_page_url = job_doc.css('.viewHead .info a')[0]['href']
      company_name = job_doc.css('.viewHead .info a')[0].text
      company_page = web_agent.get company_page_url
      company_doc = Nokogiri::HTML(company_page.body)
      company_items = company_doc.css('.tInfo-2 span').map{|item| item.text}
      company_city, company_category, company_kind, company_scale, company_address, company_zip, company_website, company_hr_name, company_tel = company_items
      company_description = company_doc.css('.infoContent').text.try(:strip)
      json = {
          job_name: job_name,
          job_salary_range: job_salary_range,
          job_recruitment_num: job_recruitment_num,
          job_published_at: job_published_at,
          job_type: job_type,
          job_category: job_category,
          job_city: job_city,
          job_mini_education: job_mini_education,
          job_mini_experience: job_mini_experience,
          job_language: job_language,
          job_description: job_description,
          job_origin_url: url,

          company_email: company_email,
          company_name: company_name,
          company_city: company_city,
          company_category: company_category,
          company_kind: company_kind,
          company_scale: company_scale,
          company_address: company_address,
          company_zip: company_zip,
          company_website: company_website,
          company_hr_name:company_hr_name,
          company_tel: company_tel,
          company_description: company_description,
          company_origin_url: company_page.uri.to_s

      }
      write_to_redis json, '91job_normal_json_queue'
      puts "[crawler] get_content #{self.class.to_s} 0 '#{json.to_json}' '#{url}'"
    rescue Exception => e
      puts "[crawler] get_content #{self.class.to_s} 1 '#{e.to_s}' '#{url}'"
    end
  end
end
