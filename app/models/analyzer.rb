class Analyzer


  EMAIL_REG = /[0-9a-zA-Z]+@[0-9a-zA-Z\.]+/
  MOBILE_REG = /[0-9]{11}/
  TEL_REG = /[0-9]{3,4}[\-\s\)]*[0-9]{8}/

  def initialize
    # @@driver = Selenium::WebDriver.for :remote, desired_capabilities: :phantomjs
    @@driver = nil
    @@machanize_agent = nil
  end


  def web_agent
    if @@machanize_agent.nil?
      @@machanize_agent = Mechanize.new
      @@machanize_agent.user_agent = "Windows Mozilla"
    end
    @@machanize_agent
  end

  def web_driver
    if @@driver && @@driver.session_id
    else
      @@driver = Selenium::WebDriver.for :remote, desired_capabilities: :phantomjs
    end
    @@driver
  end

  def Analyzer.factory(url = nil)
    if url =~ /91job.gov.cn\/campus/ ||  url =~ /91wllm.com\/campus/ ||  url =~ /zjut.jysd.com\/campus/ || url =~ /cup.jysd.com\/campus/ ||
        url =~ /job.wzu.edu.cn\/campus/ || url =~ /jyb.zstu.edu.cn\/campus/ || url =~ /zjnu.jysd.com\/campus/ || url =~ /nbpt.jysd.com\/campus/
        url =~ /jyw.jhc.cn\/campus/  || url =~ /jlnu.jysd.com\/campus/ || url =~ /gdou.jysd.com\/campus/ || url =~ /bwu.jysd.com\/campus/
      Js91jobCampus.new
    elsif  url =~ /91job.gov.cn\/job/ || url =~ /91wllm.com\/job/ ||  url =~ /zjut.jysd.com\/job/ || url =~ /cup.jysd.com\/job/ ||
        url =~ /job.wzu.edu.cn\/job/ || url =~ /jyb.zstu.edu.cn\/job/ || url =~ /zjnu.jysd.com\/job/  || url =~ /nbpt.jysd.com\/job/ ||
        url =~ /jyw.jhc.cn\/job/  || url =~ /jlnu.jysd.com\/job/ || url =~ /gdou.jysd.com\/job/   || url =~ /bwu.jysd.com\/job/
      Js91jobNormal.new
    elsif url =~ /wutongguo.com/
      Wutongguo.new
    elsif url =~ /51job/
      Job51.new
    elsif url =~ /wjjy/
      JsMarketWujing.new
    elsif url =~ /wxrcw/
      JsMarketWuxi.new
    elsif url =~ /hrol/
      JsMarketZhengjiang.new
    elsif url =~ /ntr.com.cn/
      JsMarketNantong.new
    else
      raise '需要指定 analyzer'
    end
  end


  def write_to_redis entity, queue
    begin
      $redis.zadd queue, 100, entity.to_json #queue
      puts "[crawler] write_to_redis #{self.class.to_s} 0 ''"
    rescue Exception => e
      puts "[crawler] write_to_redis #{self.class.to_s} 1 ''"
    end
    # $es.index index: 'crawler', type: 'company_job', body: entity
  end

end