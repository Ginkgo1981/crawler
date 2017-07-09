class Analyzer


  EMAIL_REG = /[0-9a-zA-Z]+@[0-9a-zA-Z\.]+/
  MOBILE_REG = /[0-9]{11}/
  TEL_REG = /[0-9]{3,4}[\-\s\)]*[0-9]{8}/

  def initialize

  end


  def Analyzer.factory(url = nil)
    uri = URI url
    host = uri.host
    if host =~ /91job.gov.cn/
      Js91job.new
    elsif host =~ /wutongguo.com/
      Wutongguo.new
    end
  end


  def sink entity
    $redis.zadd 'company_job_json_queue', 100, entity.to_json #queue
    # $es.index index: 'crawler', type: 'company_job', body: entity
  end

end