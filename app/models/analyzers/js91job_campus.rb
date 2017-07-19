class Js91jobCampus < Analyzer

  def get_links(url)
    begin
      uri = URI url
      # agent = Mechanize.new
      page = web_agent.get uri
      doc = Nokogiri::HTML(page.body)
      host = uri.host
      links = doc.css('.infoList a').map{|a| "http://#{host}#{a['href']}" }
    rescue Exception => e
      puts "[crawler] get_links #{self.class.to_s} 1 '#{e.to_s}'"
    end
  end

  def get_content(url = '')
    # url = 'http://njfu.91job.gov.cn/campus/view/id/666484'
    begin
      uri = URI url
      # agent = Mechanize.new
      job_page = web_agent.get uri
      job_doc = Nokogiri::HTML(job_page.body)
      job_name = job_doc.css('.viewHead h1').text

      # job_items_1 = job_doc.css('.xInfo span').map{|item| item.text} # ["民营企业", "张吴霜", "水利、环境和公共设施管理业", "0513-85508688", "50-300人", "1620418697@qq.com", "江苏省", "2017-06-28 09:44"]
      job_items_2 = job_doc.css('.xInfo-2 span').map{|item| item.text} # ["江苏省", "2017-06-28 09:44"]
      job_published_at = job_items_2[1]
      job_description = job_doc.css('.vContent').text.try(:strip)
      #company detail page url
      company_page_url = job_doc.css('.viewHead .info a')[0]['href']
      company_name = job_doc.css('.viewHead .info a')[0].text
      company_name = job_name.scan(/.*[公司|集团]/).first if company_name.blank?

      company_page = web_agent.get company_page_url
      company_doc = Nokogiri::HTML(company_page.body)
      company_items = company_doc.css('.tInfo-2 span').map{|item| item.text}
      company_city, company_category, company_kind, company_scale, company_address, company_zip, company_website, company_hr, company_mobile = company_items
      company_description = company_doc.css('.infoContent').text.try(:strip)
      json = {
          job_name: job_name,
          job_published_at: job_published_at,
          job_description: job_description,
          company_name: company_name,
          company_city: company_city,
          company_category: company_category,
          company_kind: company_kind,
          company_scale: company_scale,
          company_address: company_address,
          company_zip: company_zip,
          company_website: company_website,
          company_hr:company_hr,
          company_mobile: company_mobile,
          company_description: company_description
      }
      write_to_redis json, '91job_campus_json_queue'
      puts "[crawler] get_content #{self.class.to_s} 0 '#{json.to_json}'"
    rescue Exception => e
      puts "[crawler] get_content #{self.class.to_s} 1 '#{e.to_s}'"
    end9
    end
  end
end
