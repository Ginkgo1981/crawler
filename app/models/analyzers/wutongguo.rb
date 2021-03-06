class Wutongguo < Analyzer

  def get_links(url='')
    # url = 'http://www.wutongguo.com/wangshen/n1'
    begin
      uri = URI url
      # agent = Mechanize.new
      page = web_agent.get uri
      doc = Nokogiri::HTML(page.body, nil, 'gb2312')
      links = doc.css('.GovListTitle').map { |a| "http://www.wutongguo.com#{a['href']}" }
    rescue Exception => e
      puts "[crawler] get_link #{self.class.to_s} 1 '#{e.to_s}' '#{url}'"
    end
  end

  def get_content(url = '')
    begin
      json_company_jobs = []
      # url = 'http://m.wutongguo.com/notice6C63594044.html'
      uri = URI url
      # agent = Mechanize.new
      page = web_agent.get uri
      doc = Nokogiri::HTML(page.body, nil, 'gb2312')
      company_name = doc.css('.HeadContent>div')[0].text
      company_city, company_scale, company_kind, company_category = doc.css('.HeadContent>div')[1].text.strip.split /\|/
      company_description = doc.css('.brod_text').text.strip
      job_published_at = Date.strptime(doc.css('.date .txt_grey89').text.scan(/(\d{4}年\d{1,2}月\d{1,2}日)/).flatten[0], "%Y年%m月%d日").strftime("%Y-%m-%d")
      #解析公司简介中的信息,找出对应的 email mobile
      # company_email = (company_description || '').scan(EMAIL_REG).try(:first)
      # company_mobile =(company_description || '').scan(MOBILE_REG).try(:first)
      # company_tel =   (company_description || '').scan(TEL_REG).try(:first)
      json_company =
          {
              company_name: company_name,
              company_city: company_city,
              company_scale: company_scale,
              company_kind: company_kind,
              company_category: company_category,
              company_description: company_description,
              # company_email: company_email,
              # company_mobile: company_mobile,
              # company_tel: company_tel,
              company_origin_url: url
          }
      job_urls = doc.css('.bro_job').select { |a| a['href'] =~ /job/ }.map { |a| "http://m.wutongguo.com#{a['href']}" }
      job_urls.each do |job_url|
        # puts "[analyzer] wutongguo get_content job_url #{job_url}"
        job_page = web_agent.get job_url
        job_doc = Nokogiri::HTML(job_page.body, nil, 'gb2312')
        job_name = job_doc.css('.txt_link').text
        job_items = job_doc.css('.cp_ln').map { |i| i.text.split(/：/)[1].try(:strip) }
        job_recruitment_num, job_mini_education, job_type, job_city, _, _ = job_items
        job_description = job_doc.css('.cp_box .cp_ln')[5].try(:text).try(:strip)
        job_majors = job_doc.css('.major_box').map { |item| item.text.try(:strip) }
        #如果在 apply里找到 手机号/email,则重写
        # company_mobile = (job_doc.css('#btn_apply')&.attribute('onclick').value || '').scan(MOBILE_REG)
        # company_email =  (job_doc.css('#btn_apply')&.attribute('onclick').value || '').scan(EMAIL_REG)
        # json_company.merge!({company_mobile: company_mobile[0]}) if company_mobile.present?
        # json_company.merge!({company_email: company_email[0]}) if company_email.present?
        json_job =
            {
                job_name: job_name,
                job_recruitment_num: job_recruitment_num,
                job_mini_education: job_mini_education,
                job_type: job_type,
                job_city: job_city,
                job_majors: job_majors,
                job_description: job_description,
                job_origin_url: job_page.uri.to_s,
                job_published_at: job_published_at
            }
        json_company_jobs << json_company.merge(json_job)
      end
      json_company_jobs
      # json_company_jobs.each do |j|
      #   puts "[crawler] get_content #{self.class.to_s} 0 '#{j.to_json}' '#{url}'"
      #   write_to_redis j
      # end
    rescue Exception => e
      puts "[crawler] get_content #{self.class.to_s} 1 '#{e.to_s}' '#{url}'"
    end
  end

end
