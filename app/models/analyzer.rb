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
      @@machanize_agent.user_agent_alias = "Windows Mozilla"
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
    if url =~ /91job.gov.cn\/campus/
      Js91jobCampus.new
    elsif  url =~ /91job.gov.cn\/job/
      Js91jobNormal.new
    elsif url =~ /wutongguo.com/
      Wutongguo.new
    elsif url =~ /51job/
      Job51.new
    elsif url =~ /wjjy/
      JsMarketWujing.new
    end
  end


  def write_to_redis entity, queue
    begin
      $redis.zadd queue, 100, entity.to_json #queue
      puts "[analyzer] sink #{self.to_s} 0 '#{entity.to_json}'"
    rescue Exception => e
      puts "[analyzer] sink error 0 ''"
    end
    # $es.index index: 'crawler', type: 'company_job', body: entity
  end

end