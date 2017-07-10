class Js91job < Analyzer

  def get_links(url)
    begin
      uri = URI url
      agent = Mechanize.new
      page = agent.get uri
      doc = Nokogiri::HTML(page.body)
      host = uri.host
      links = doc.css('.infoList .span1 a').map{|a| "http://#{host}#{a['href']}" }
    rescue Exception => e
      puts "[analyzer] get_links #{self.to_s} 0 'error'"
    end
  end

  def get_content(url = '')
    # url = 'http://njfu0.91job.gov.cn/job/view/id/1217733'
    begin
      url = $redis.zrange('link_queue', 0, 0).first
      uri = URI url
      agent = Mechanize.new
      job_page = agent.get uri
      job_doc = Nokogiri::HTML(job_page.body)
      job_name = job_doc.css('.viewHead h1').text
      job_items = job_doc.css('.xInfo-2 span').map{|item| item.text}
      job_salary_range, job_recruitment_num, job_published_at, job_type, job_category,
          job_city, job_mini_education, job_mini_experience,job_language = job_items
      job_description = job_doc.css('.vContent.cl').text.try(:strip)
      #company detail page url
      company_page_url = job_doc.css('.viewHead .info a')[0]['href']
      company_name = job_doc.css('.viewHead .info a')[0].text
      company_page = agent.get company_page_url
      company_doc = Nokogiri::HTML(company_page.body)
      company_items = company_doc.css('.tInfo-2 span').map{|item| item.text}
      company_city, company_category, company_kind, company_scale, company_address, company_zip, company_website, company_hr, company_mobile = company_items
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
      sink json
      puts "[analyzer] get_content #{self.to_s} 0 '#{json.to_json}'"
    rescue Exception => e
      puts "[analyzer] get_content #{self.to_s} 0 'error'"
    end
  end
  # http://www.91job.gov.cn/job/view/id/1203398
  # def process(url)
  #   uri = URI url
  #   agent = Mechanize.new
  #   page = agent.get uri
  #   doc = Nokogiri::HTML(page.body)
  #   section1 = doc.css('.css-article-info p').text.strip
  #   array1 = section1.scan(/(?:[\S]{4}\s:\s)([\S^]+)\w*/).flatten
  #
  #   company_kind, company_industry, company_scale, job_type, job_published_at, job_mini_experience, job_mini_education,
  #       job_recruitment_num, job_language, job_city, job_salary_range, job_category = array1
  #   section2 = doc.css('.css-tit~div').text.strip
  #
  #   # r = /(\S+)[\n\t]+[\S\s]{4}/ #use for scan
  #
  #   r2 = /(\S+)[\n\t\s]*[\S]{4}[\n\t\s]*[\S]{4}[\n\t\s]*([\S]+)[\n\t\s]*[\S]{3}([\S]+)[\n\t\s]*[\S]{5}([\S]+)[\n\t\s]*/
  #   array2 = section2.match(r2).captures.flatten
  #   job_description, company_description, company_mobile, company_email = array2
  #   job_name = doc.css('.css-title.text-center').text
  #   json =
  #       {
  #           company_name: '',
  #           company_scale: company_scale,
  #           company_logo: '',
  #           company_kind: company_kind,
  #           company_city: job_city,
  #           company_address: '',
  #           company_description: company_description,
  #           company_email: company_email,
  #           company_mobile: company_mobile,
  #           company_contact_name: '',
  #           job_name: job_name,
  #           job_city: job_city,
  #           job_address: '',
  #           job_description: job_description,
  #           job_salary_range: job_salary_range,
  #
  #           job_type: job_type,
  #           job_published_at: job_published_at,
  #           job_mini_education: job_mini_experience,
  #           job_recruitment_num: job_recruitment_num,
  #           job_language: job_language,
  #           job_category: job_category
  #       }
  # end

end
