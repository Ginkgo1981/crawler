class Analyzer


  EMAIL_REG = /[0-9a-zA-Z]+@[0-9a-zA-Z\.]+/
  MOBILE_REG = /[0-9]{11}/
  TEL_REG = /[0-9]{3,4}[\-\s\)]*[0-9]{8}/

  def initialize

  end


  def Analyzer.factory(url = nil)
    # uri = URI url
    # host = uri.host
    # if host =~ /91job.gov.cn/
    #   Js91jobNormal.new
    # elsif host =~ /wutongguo.com/
    #   Wutongguo.new
    # end

    if url =~ /91job.gov.cn\/campus/
      Js91jobCampus.new
    elsif  url =~ /91job.gov.cn\/job/
      Js91jobNormal.new
    elsif url =~ /wutongguo.com/
      Wutongguo.new
    elsif url =~ /51job/
      Job51.new
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