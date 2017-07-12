namespace :qiaobu do
  desc "extract_benefits_skills_categories"
  task extract_benefits_skills_categories: :environment do

    #乔布简历的招聘信息有点 low, 定期运行这个 rake抓取 benefits,  skill, categories
    url = 'http://job.qiaobutang.com/app/jobs.json'
    uri = URI url
    agent = Mechanize.new
    page = agent.get uri
    formatted = JSON(page.body)
    benefits = formatted['result'].map { |t| t['job']['benefit']&.map { |s| s['tag'] } }.flatten.uniq
    puts "[乔布简历] benefits"
    puts benefits
    benefits.each { |b| Benefit.find_or_create_by name: b }
    skills = formatted['result'].map { |t| t['job']['skill']&.split /[\,\，\、]/ }.flatten.uniq
    puts "[乔布简历] skills"
    puts skills

    skills.each { |s| Skill.find_or_create_by name: s }
    categories = formatted['result'].map { |t| t['job']['categories'] }.flatten.uniq
    puts "[乔布简历] categories"
    puts categories
    categories.each { |c| Category.find_or_create_by name: c }
  end


  desc "extract_honors"
  task extract_honors: :environment do
    HonorTip.destroy_all
    url = 'http://cv.qiaobutang.com/rest/app/career/honors/tips.json?at=1499525434738&resolution=4x&sig=6408d299b9db76075a4245b91f085095&uid=57d180030cf2123d500195a9&v=13'
    uri = URI url
    agent = Mechanize.new
    page = agent.get uri
    formatted = JSON(page.body)

    formatted['career_honor_tips'].each do |item|
      name = item['name']
      pp name
      HonorTip.create! name: name, tips: item['tips']
    end
  end

  desc "extract_interest_tags"
  task extract_interest_tags: :environment do
    InterestTag.destroy_all
    %w(
     http://cv.qiaobutang.com/rest/app/connection/interested/tags.json?at=1499523313219&intentName=%E7%94%B5%E5%95%86&resolution=4x&sig=b80a4f32238fbad5a84a112f14311bd1&uid=57d180030cf2123d500195a9&v=13
     http://cv.qiaobutang.com/rest/app/connection/interested/tags.json?at=1499523326466&intentName=%E7%94%B5%E5%95%86&resolution=4x&sig=a855e3c8cc9fe6863db21ed10b07090e&uid=57d180030cf2123d500195a9&v=13
     http://cv.qiaobutang.com/rest/app/connection/interested/tags.json?at=1499523329284&intentName=%E5%BD%B1%E8%A7%86%E6%88%8F%E5%89%A7&resolution=4x&sig=bb1ed2dd59f4befd34c9bda9d8e2633f&uid=57d180030cf2123d500195a9&v=13
     http://cv.qiaobutang.com/rest/app/connection/interested/tags.json?at=1499523332016&intentName=%E6%95%99%E5%B8%88&resolution=4x&sig=e31254cd446df1f11134387f4b0233e2&uid=57d180030cf2123d500195a9&v=13
     http://cv.qiaobutang.com/rest/app/connection/interested/tags.json?at=1499523334476&intentName=%E5%8C%BB%E6%8A%A4&resolution=4x&sig=a7ab6cfe61a39a3f3bc39c4053b21242&uid=57d180030cf2123d500195a9&v=13
     http://cv.qiaobutang.com/rest/app/connection/interested/tags.json?at=1499523336766&intentName=%E7%8C%8E%E5%A4%B4&resolution=4x&sig=d99a2981e905df5af3d3d4c1a3b29af2&uid=57d180030cf2123d500195a9&v=13
     http://cv.qiaobutang.com/rest/app/connection/interested/tags.json?at=1499523340530&intentName=%E9%9F%B3%E4%B9%90&resolution=4x&sig=b6a6ae1db0fc5c9bfaca50586d63b636&uid=57d180030cf2123d500195a9&v=13
     http://cv.qiaobutang.com/rest/app/connection/interested/tags.json?at=1499523343213&intentName=%E8%BD%AF%E4%BB%B6&resolution=4x&sig=83e6a1cb7692f7f0168df84de5614379&uid=57d180030cf2123d500195a9&v=13
     http://cv.qiaobutang.com/rest/app/connection/interested/tags.json?at=1499523347415&intentName=%E7%94%9F%E7%89%A9&resolution=4x&sig=52950d46f55824db322fb000867a44e8&uid=57d180030cf2123d500195a9&v=13
     http://cv.qiaobutang.com/rest/app/connection/interested/tags.json?at=1499523350572&intentName=%E5%88%B6%E8%8D%AF&resolution=4x&sig=95ca73ef042dd102b51864e4c700c122&uid=57d180030cf2123d500195a9&v=13
     http://cv.qiaobutang.com/rest/app/connection/interested/tags.json?at=1499523353682&intentName=%E5%9C%9F%E6%9C%A8&resolution=4x&sig=0c1bab79328b52667624e8aabd765d9f&uid=57d180030cf2123d500195a9&v=13
     http://cv.qiaobutang.com/rest/app/connection/interested/tags.json?at=1499523357540&intentName=%E6%9C%BA%E6%A2%B0&resolution=4x&sig=5345996afc43dea90c9389b1ff4f3276&uid=57d180030cf2123d500195a9&v=13
     http://cv.qiaobutang.com/rest/app/connection/interested/tags.json?at=1499523343213&intentName=%E8%BD%AF%E4%BB%B6&resolution=4x&sig=83e6a1cb7692f7f0168df84de5614379&uid=57d180030cf2123d500195a9&v=13
     http://cv.qiaobutang.com/rest/app/connection/interested/tags.json?at=1499523347415&intentName=%E7%94%9F%E7%89%A9&resolution=4x&sig=52950d46f55824db322fb000867a44e8&uid=57d180030cf2123d500195a9&v=13
     http://cv.qiaobutang.com/rest/app/connection/interested/tags.json?at=1499523350572&intentName=%E5%88%B6%E8%8D%AF&resolution=4x&sig=95ca73ef042dd102b51864e4c700c122&uid=57d180030cf2123d500195a9&v=13
     http://cv.qiaobutang.com/rest/app/connection/interested/tags.json?at=1499523353682&intentName=%E5%9C%9F%E6%9C%A8&resolution=4x&sig=0c1bab79328b52667624e8aabd765d9f&uid=57d180030cf2123d500195a9&v=13
     http://cv.qiaobutang.com/rest/app/connection/interested/tags.json?at=1499523357540&intentName=%E6%9C%BA%E6%A2%B0&resolution=4x&sig=5345996afc43dea90c9389b1ff4f3276&uid=57d180030cf2123d500195a9&v=13
     http://cv.qiaobutang.com/rest/app/connection/interested/tags.json?at=1499523363323&intentName=%E7%94%B5%E6%B0%94&resolution=4x&sig=e97b4474bbd3dd3b9666b36dd4973cc4&uid=57d180030cf2123d500195a9&v=13
     http://cv.qiaobutang.com/rest/app/connection/interested/tags.json?at=1499523366824&intentName=%E7%94%B5%E5%AD%90&resolution=4x&sig=a22dd465b48ec21e1ce02b2167388f8a&uid=57d180030cf2123d500195a9&v=13
     http://cv.qiaobutang.com/rest/app/connection/interested/tags.json?at=1499523371458&intentName=%E5%8C%96%E5%B7%A5&resolution=4x&sig=fd1cdc5df0b96b460bbf84d3275653ec&uid=57d180030cf2123d500195a9&v=13
     http://cv.qiaobutang.com/rest/app/connection/interested/tags.json?at=1499523375008&intentName=%E6%9D%90%E6%96%99&resolution=4x&sig=6cc643d0962b5e5ca325399f04d93840&uid=57d180030cf2123d500195a9&v=13
     http://cv.qiaobutang.com/rest/app/connection/interested/tags.json?at=1499523378839&intentName=%E4%BF%9D%E9%99%A9&resolution=4x&sig=4e7cebddbb4c29e0320b598ec5d334df&uid=57d180030cf2123d500195a9&v=13
     http://cv.qiaobutang.com/rest/app/connection/interested/tags.json?at=1499523383196&intentName=%E8%AF%81%E5%88%B8&resolution=4x&sig=bbce4e3e5e571e85bfc4639fc6399de7&uid=57d180030cf2123d500195a9&v=13
     http://cv.qiaobutang.com/rest/app/connection/interested/tags.json?at=1499523388421&intentName=%E9%93%B6%E8%A1%8C&resolution=4x&sig=097f29e2dfffc16bdb6cd492cc5b3c59&uid=57d180030cf2123d500195a9&v=13
     http://cv.qiaobutang.com/rest/app/connection/interested/tags.json?at=1499523393781&intentName=%E4%BC%9A%E5%B1%95&resolution=4x&sig=3c3049864be90fe7f61ee703b03cc796&uid=57d180030cf2123d500195a9&v=13
     http://cv.qiaobutang.com/rest/app/connection/interested/tags.json?at=1499523401546&intentName=%E5%A4%96%E8%B4%B8&resolution=4x&sig=513725a616e4cd6adbc85adcc0c444c8&uid=57d180030cf2123d500195a9&v=13
     http://cv.qiaobutang.com/rest/app/connection/interested/tags.json?at=1499523407681&intentName=%E9%80%9A%E4%BF%A1%EF%BC%88%E6%8A%80%E6%9C%AF%E7%B1%BB%EF%BC%89&resolution=4x&sig=c1491fb9019859ee9cc547cbdb5f1f65&uid=57d180030cf2123d500195a9&v=13
     http://cv.qiaobutang.com/rest/app/connection/interested/tags.json?at=1499523401546&intentName=%E5%A4%96%E8%B4%B8&resolution=4x&sig=513725a616e4cd6adbc85adcc0c444c8&uid=57d180030cf2123d500195a9&v=13
     http://cv.qiaobutang.com/rest/app/connection/interested/tags.json?at=1499523407681&intentName=%E9%80%9A%E4%BF%A1%EF%BC%88%E6%8A%80%E6%9C%AF%E7%B1%BB%EF%BC%89&resolution=4x&sig=c1491fb9019859ee9cc547cbdb5f1f65&uid=57d180030cf2123d500195a9&v=13
     http://cv.qiaobutang.com/rest/app/connection/interested/tags.json?at=1499523412392&intentName=%E8%A1%8C%E6%94%BF%E6%96%87%E7%A7%98&resolution=4x&sig=2674cbdde153b6de42dbb5192013d9c5&uid=57d180030cf2123d500195a9&v=13
     http://cv.qiaobutang.com/rest/app/connection/interested/tags.json?at=1499523417082&intentName=%E5%AE%A2%E6%9C%8D&resolution=4x&sig=31b9064f964adf881be4a73647026887&uid=57d180030cf2123d500195a9&v=13
     http://cv.qiaobutang.com/rest/app/connection/interested/tags.json?at=1499523424893&intentName=%E9%94%80%E5%94%AE&resolution=4x&sig=deeb6a927a0956785495a495edd5c461&uid=57d180030cf2123d500195a9&v=13
     http://cv.qiaobutang.com/rest/app/connection/interested/tags.json?at=1499523434178&intentName=%E8%AE%B0%E8%80%85/%E7%BC%96%E8%BE%91&resolution=4x&sig=8eae4291d5bf0ad5e1ddd80c07d1c6fa&uid=57d180030cf2123d500195a9&v=13
     http://cv.qiaobutang.com/rest/app/connection/interested/tags.json?at=1499523438902&intentName=%E6%8A%95%E8%A1%8C&resolution=4x&sig=b6b66fc0f90b3e20c9ee5073acff8c8f&uid=57d180030cf2123d500195a9&v=13
     http://cv.qiaobutang.com/rest/app/connection/interested/tags.json?at=1499523444712&intentName=%E5%BE%8B%E5%B8%88%E5%8A%A9%E7%90%86/%E6%B3%95%E5%8A%A1&resolution=4x&sig=4bcb0d064e2f84d069308a5c1063ed65&uid=57d180030cf2123d500195a9&v=13
     http://cv.qiaobutang.com/rest/app/connection/interested/tags.json?at=1499523453000&intentName=%E5%92%A8%E8%AF%A2&resolution=4x&sig=a12c24ac3a8107d2750547284a9616df&uid=57d180030cf2123d500195a9&v=13
     http://cv.qiaobutang.com/rest/app/connection/interested/tags.json?at=1499523460504&intentName=%E7%89%A9%E6%B5%81&resolution=4x&sig=ce5686f54052fc54dd5774a2333357cc&uid=57d180030cf2123d500195a9&v=13
     http://cv.qiaobutang.com/rest/app/connection/interested/tags.json?at=1499523466573&intentName=%E8%89%BA%E6%9C%AF%E8%AE%BE%E8%AE%A1&resolution=4x&sig=582aa48abe9f2f81097f467f87c3400f&uid=57d180030cf2123d500195a9&v=13
     http://cv.qiaobutang.com/rest/app/connection/interested/tags.json?at=1499523472129&intentName=%E8%B4%A2%E5%8A%A1&resolution=4x&sig=8c73598c44b4c626b0bc98e119d2fb40&uid=57d180030cf2123d500195a9&v=13
     http://cv.qiaobutang.com/rest/app/connection/interested/tags.json?at=1499523478035&intentName=%E9%80%9A%E7%94%A8&resolution=4x&sig=c1b54a963320eec1adaa42aea80e25fe&uid=57d180030cf2123d500195a9&v=13
     http://cv.qiaobutang.com/rest/app/connection/interested/tags.json?at=1499523417082&intentName=%E5%AE%A2%E6%9C%8D&resolution=4x&sig=31b9064f964adf881be4a73647026887&uid=57d180030cf2123d500195a9&v=13
     http://cv.qiaobutang.com/rest/app/connection/interested/tags.json?at=1499523424893&intentName=%E9%94%80%E5%94%AE&resolution=4x&sig=deeb6a927a0956785495a495edd5c461&uid=57d180030cf2123d500195a9&v=13
     http://cv.qiaobutang.com/rest/app/connection/interested/tags.json?at=1499523434178&intentName=%E8%AE%B0%E8%80%85/%E7%BC%96%E8%BE%91&resolution=4x&sig=8eae4291d5bf0ad5e1ddd80c07d1c6fa&uid=57d180030cf2123d500195a9&v=13
     http://cv.qiaobutang.com/rest/app/connection/interested/tags.json?at=1499523438902&intentName=%E6%8A%95%E8%A1%8C&resolution=4x&sig=b6b66fc0f90b3e20c9ee5073acff8c8f&uid=57d180030cf2123d500195a9&v=13
     http://cv.qiaobutang.com/rest/app/connection/interested/tags.json?at=1499523444712&intentName=%E5%BE%8B%E5%B8%88%E5%8A%A9%E7%90%86/%E6%B3%95%E5%8A%A1&resolution=4x&sig=4bcb0d064e2f84d069308a5c1063ed65&uid=57d180030cf2123d500195a9&v=13
     http://cv.qiaobutang.com/rest/app/connection/interested/tags.json?at=1499523453000&intentName=%E5%92%A8%E8%AF%A2&resolution=4x&sig=a12c24ac3a8107d2750547284a9616df&uid=57d180030cf2123d500195a9&v=13
     http://cv.qiaobutang.com/rest/app/connection/interested/tags.json?at=1499523460504&intentName=%E7%89%A9%E6%B5%81&resolution=4x&sig=ce5686f54052fc54dd5774a2333357cc&uid=57d180030cf2123d500195a9&v=13
     http://cv.qiaobutang.com/rest/app/connection/interested/tags.json?at=1499523466573&intentName=%E8%89%BA%E6%9C%AF%E8%AE%BE%E8%AE%A1&resolution=4x&sig=582aa48abe9f2f81097f467f87c3400f&uid=57d180030cf2123d500195a9&v=13
     http://cv.qiaobutang.com/rest/app/connection/interested/tags.json?at=1499523472129&intentName=%E8%B4%A2%E5%8A%A1&resolution=4x&sig=8c73598c44b4c626b0bc98e119d2fb40&uid=57d180030cf2123d500195a9&v=13
     http://cv.qiaobutang.com/rest/app/connection/interested/tags.json?at=1499523478035&intentName=%E9%80%9A%E7%94%A8&resolution=4x&sig=c1b54a963320eec1adaa42aea80e25fe&uid=57d180030cf2123d500195a9&v=13
     http://cv.qiaobutang.com/rest/app/connection/interested/tags.json?at=1499523491142&intentName=%E4%BA%BA%E5%8A%9B%E8%B5%84%E6%BA%90&resolution=4x&sig=47fdfa534f8e1d625097dec38e9eef5b&uid=57d180030cf2123d500195a9&v=13
     http://cv.qiaobutang.com/rest/app/connection/interested/tags.json?at=1499523495859&intentName=%E5%B8%82%E5%9C%BA%E8%90%A5%E9%94%80&resolution=4x&sig=46059cf3203bd93b68135c5033831e75&uid=57d180030cf2123d500195a9&v=13
    ).each do |url|
      intent = URI.unescape(url).split(/=/)[2].split(/&/)[0]
      uri = URI url
      puts url
      agent = Mechanize.new
      page = agent.get uri
      formatted = JSON(page.body)
      formatted['tags'].each do |json|
        pp json
        InterestTag.create! intent: intent, name: json['name']
      end
    end
  end



  desc "extract_industry"
  task extract_industry: :environment do
    url = 'http://cv.qiaobutang.com/rest/app/internships/all_intent.json?at=1499518220733&resolution=4x&sig=6b78dc152f1440298f394b0111931b7c&uid=57d180030cf2123d500195a9&v=13'
    uri = URI url
    agent = Mechanize.new
    page = agent.get uri
    formatted = JSON(page.body)
    formatted['tags'].each do |json|
      pp json
      Industry.create! uuid: json['id'], name: json['name']
    end
  end

  desc 'extract_industry_experiences'
  task extract_industry_experiences: :environment do
    %w(
      http://cv.qiaobutang.com/rest/app/career/experiences/modelessays.json?at=1499518502346&intention=4f71367ce18f7c72253cfa8a&resolution=4x&sig=4288a3ca43a7c9500a3a3de0420719aa&uid=57d180030cf2123d500195a9&v=13
      http://cv.qiaobutang.com/rest/app/career/experiences/modelessays.json?at=1499518508750&intention=52a141700cf2e5e81fbeaea6&resolution=4x&sig=53a67722fad5b4c23a6b45f7769c8a4d&uid=57d180030cf2123d500195a9&v=13
      http://cv.qiaobutang.com/rest/app/career/experiences/modelessays.json?at=1499518512636&intention=4f71367ce18f7c72253cfa8a&resolution=4x&sig=8a6de34a9c7a77a9abb3fd0b2ae89f1b&uid=57d180030cf2123d500195a9&v=13
      http://cv.qiaobutang.com/rest/app/career/experiences/modelessays.json?at=1499518517430&intention=5194b6040cf2f49d1f1de3ba&resolution=4x&sig=c241f056ab309b6e7028faf0596d68c8&uid=57d180030cf2123d500195a9&v=13
      http://cv.qiaobutang.com/rest/app/career/experiences/modelessays.json?at=1499518519865&intention=516b62000cf2b34266e101e9&resolution=4x&sig=ec6de3ed33a5084e8de4a9ff1f97caf4&uid=57d180030cf2123d500195a9&v=13
      http://cv.qiaobutang.com/rest/app/career/experiences/modelessays.json?at=1499518522965&intention=5110a33f0cf2fecde6fdaba8&resolution=4x&sig=2022eb1c81304c6f215321a2ec9f256c&uid=57d180030cf2123d500195a9&v=13
      http://cv.qiaobutang.com/rest/app/career/experiences/modelessays.json?at=1499518525588&intention=510f194a0cf2be8e9874798f&resolution=4x&sig=54c6f6fb5bc66423ca3bddf989109476&uid=57d180030cf2123d500195a9&v=13
      http://cv.qiaobutang.com/rest/app/career/experiences/modelessays.json?at=1499518528269&intention=4f71367ce18f7c72253cfa8a&resolution=4x&sig=8d0e2abfb08b3526cd37f6c28599ce05&uid=57d180030cf2123d500195a9&v=13
      http://cv.qiaobutang.com/rest/app/career/experiences/modelessays.json?at=1499518531255&intention=4f7135d3e18f7c72253cfa87&resolution=4x&sig=1c3cb118df45dd40e859f44b537ffa93&uid=57d180030cf2123d500195a9&v=13
      http://cv.qiaobutang.com/rest/app/career/experiences/modelessays.json?at=1499518534169&intention=4f7135cde18f7c72253cfa86&resolution=4x&sig=23f8d6905b186f6daafc563915557456&uid=57d180030cf2123d500195a9&v=13
      http://cv.qiaobutang.com/rest/app/career/experiences/modelessays.json?at=1499518537586&intention=4f5cd252e18fd083c0124015&resolution=4x&sig=be90d031e38fbd78e938411c79cde44d&uid=57d180030cf2123d500195a9&v=13
      http://cv.qiaobutang.com/rest/app/career/experiences/modelessays.json?at=1499518540932&intention=4f5cd24de18fd083c0124014&resolution=4x&sig=1bbc4cfcdb8a0e41ef839f8a3c3f5dcb&uid=57d180030cf2123d500195a9&v=13
      http://cv.qiaobutang.com/rest/app/career/experiences/modelessays.json?at=1499518546224&intention=4f5cd24de18fd083c0124014&resolution=4x&sig=2e32e9e5a0ec56b3c191681500f643ab&uid=57d180030cf2123d500195a9&v=13
      http://cv.qiaobutang.com/rest/app/career/experiences/modelessays.json?at=1499518549205&intention=4f5cd1d8e18fd083c012400d&resolution=4x&sig=dd3d3c1f427cc9cbc60770a583d83dd2&uid=57d180030cf2123d500195a9&v=13
      http://cv.qiaobutang.com/rest/app/career/experiences/modelessays.json?at=1499518552758&intention=4f5cd0d9e18fd083c0124008&resolution=4x&sig=9ada0b869798871e065bc48368cca2f7&uid=57d180030cf2123d500195a9&v=13
      http://cv.qiaobutang.com/rest/app/career/experiences/modelessays.json?at=1499518558821&intention=4f5cd00be18fd083c0124007&resolution=4x&sig=a2dead73eafb06c3f88b39ba63b2ece1&uid=57d180030cf2123d500195a9&v=13
      http://cv.qiaobutang.com/rest/app/career/experiences/modelessays.json?at=1499518552758&intention=4f5cd0d9e18fd083c0124008&resolution=4x&sig=9ada0b869798871e065bc48368cca2f7&uid=57d180030cf2123d500195a9&v=13
      http://cv.qiaobutang.com/rest/app/career/experiences/modelessays.json?at=1499518558821&intention=4f5cd00be18fd083c0124007&resolution=4x&sig=a2dead73eafb06c3f88b39ba63b2ece1&uid=57d180030cf2123d500195a9&v=13
      http://cv.qiaobutang.com/rest/app/career/experiences/modelessays.json?at=1499518564973&intention=4f59a6c8e18fc24a45ecfba4&resolution=4x&sig=e3779a6c8fccf1b15a3ba455988ee3b8&uid=57d180030cf2123d500195a9&v=13
      http://cv.qiaobutang.com/rest/app/career/experiences/modelessays.json?at=1499518569477&intention=4f59a6c8e18fc24a45ecfba4&resolution=4x&sig=0ec14502f6e5bcb45ee1716ca4d8c4ec&uid=57d180030cf2123d500195a9&v=13
      http://cv.qiaobutang.com/rest/app/career/experiences/modelessays.json?at=1499518574211&intention=4f59a6b9e18fc24a45ecfba3&resolution=4x&sig=92d55aceb82f9be3c3495404b775375b&uid=57d180030cf2123d500195a9&v=13
      http://cv.qiaobutang.com/rest/app/career/experiences/modelessays.json?at=1499518578228&intention=4f59a42fe18fc24a45ecfba1&resolution=4x&sig=5c6bea176d03b519181976fbe77af2f9&uid=57d180030cf2123d500195a9&v=13
      http://cv.qiaobutang.com/rest/app/career/experiences/modelessays.json?at=1499518583574&intention=4f59a42fe18fc24a45ecfba1&resolution=4x&sig=998067f070375353ebc7e24ad84d2fa3&uid=57d180030cf2123d500195a9&v=13
      http://cv.qiaobutang.com/rest/app/career/experiences/modelessays.json?at=1499518601603&intention=4f562f1fe18fc24a45ecfa7c&resolution=4x&sig=fe80dfccbb8bd4b1227a66434e85cb7b&uid=57d180030cf2123d500195a9&v=13
      http://cv.qiaobutang.com/rest/app/career/experiences/modelessays.json?at=1499518611334&intention=4f562f05e18fc24a45ecfa7b&resolution=4x&sig=c834e53967649dc8596e5a21950d6ed9&uid=57d180030cf2123d500195a9&v=13
      http://cv.qiaobutang.com/rest/app/career/experiences/modelessays.json?at=1499518618143&intention=4f562ef4e18fc24a45ecfa7a&resolution=4x&sig=0fe6143044324ffe195f20816a1c6cb4&uid=57d180030cf2123d500195a9&v=13
      http://cv.qiaobutang.com/rest/app/career/experiences/modelessays.json?at=1499518623552&intention=4f562c5ae18fc24a45ecfa75&resolution=4x&sig=01572ca86fdbc2cd05b60c2db72b878e&uid=57d180030cf2123d500195a9&v=13
      http://cv.qiaobutang.com/rest/app/career/experiences/modelessays.json?at=1499518629385&intention=4f466415e18f226d073d201f&resolution=4x&sig=b36ed709f261ebc99623ab8d2d07273b&uid=57d180030cf2123d500195a9&v=13
      http://cv.qiaobutang.com/rest/app/career/experiences/modelessays.json?at=1499518634430&intention=4f46519ee18f226d073d201d&resolution=4x&sig=ac066c89a4b2ac45f588875fa4a4f5fd&uid=57d180030cf2123d500195a9&v=13
      http://cv.qiaobutang.com/rest/app/career/experiences/modelessays.json?at=1499518639253&intention=4f44d25fe18f6f0d5dd1c8a6&resolution=4x&sig=c663d01e3fcdbd57af1aba2253a07846&uid=57d180030cf2123d500195a9&v=13
      http://cv.qiaobutang.com/rest/app/career/experiences/modelessays.json?at=1499518623552&intention=4f562c5ae18fc24a45ecfa75&resolution=4x&sig=01572ca86fdbc2cd05b60c2db72b878e&uid=57d180030cf2123d500195a9&v=13
      http://cv.qiaobutang.com/rest/app/career/experiences/modelessays.json?at=1499518629385&intention=4f466415e18f226d073d201f&resolution=4x&sig=b36ed709f261ebc99623ab8d2d07273b&uid=57d180030cf2123d500195a9&v=13
      http://cv.qiaobutang.com/rest/app/career/experiences/modelessays.json?at=1499518634430&intention=4f46519ee18f226d073d201d&resolution=4x&sig=ac066c89a4b2ac45f588875fa4a4f5fd&uid=57d180030cf2123d500195a9&v=13
      http://cv.qiaobutang.com/rest/app/career/experiences/modelessays.json?at=1499518639253&intention=4f44d25fe18f6f0d5dd1c8a6&resolution=4x&sig=c663d01e3fcdbd57af1aba2253a07846&uid=57d180030cf2123d500195a9&v=13
      http://cv.qiaobutang.com/rest/app/career/experiences/modelessays.json?at=1499518647039&intention=4f0fe473e18f6744062b6265&resolution=4x&sig=1e5dc92d3045d07c001fb97717001fec&uid=57d180030cf2123d500195a9&v=13
      http://cv.qiaobutang.com/rest/app/career/experiences/modelessays.json?at=1499518654656&intention=4f0e415be18f6744062b6255&resolution=4x&sig=a3cf7aa6d31e44555cb9bd1618f9315c&uid=57d180030cf2123d500195a9&v=13
      http://cv.qiaobutang.com/rest/app/career/experiences/modelessays.json?at=1499518660373&intention=4f050421e18f494f88a43848&resolution=4x&sig=0a2d92de1da2e8e63b0986afd0251ff0&uid=57d180030cf2123d500195a9&v=13
      http://cv.qiaobutang.com/rest/app/career/experiences/modelessays.json?at=1499518668928&intention=4eee4627e18f6744062b61a2&resolution=4x&sig=3dfeda665db31a39fbf8f2f29577e921&uid=57d180030cf2123d500195a9&v=13
      http://cv.qiaobutang.com/rest/app/career/experiences/modelessays.json?at=1499518682706&intention=4ecb8e62e18f6744062b5f84&resolution=4x&sig=e0708f060f6cca044205ec5de513b603&uid=57d180030cf2123d500195a9&v=13
      http://cv.qiaobutang.com/rest/app/career/experiences/modelessays.json?at=1499518687977&intention=4e9c193de18fe3b85d615ddd&resolution=4x&sig=85fd5fae7210a43ea44d7d96f60c2322&uid=57d180030cf2123d500195a9&v=13
      http://cv.qiaobutang.com/rest/app/career/experiences/modelessays.json?at=1499518693961&intention=4e6f3ac1e18f570b3919a3e1&resolution=4x&sig=e79454c90a025cc3d4970d6d19118f9f&uid=57d180030cf2123d500195a9&v=13
      http://cv.qiaobutang.com/rest/app/career/experiences/modelessays.json?at=1499518698595&intention=4e30ba76844e8fe17e54da37&resolution=4x&sig=487b2e5835ca951739eba32ffa0f200e&uid=57d180030cf2123d500195a9&v=13
      http://cv.qiaobutang.com/rest/app/career/experiences/modelessays.json?at=1499518702626&intention=4e0017dea1518fe16ee88728&resolution=4x&sig=56d24a2181a7bcf54e27e976b1130d86&uid=57d180030cf2123d500195a9&v=13 ).uniq.each do |url|
      pp url
      uuid = url.split(/\&/)[1].split(/\=/)[1]
      uri = URI url
      agent = Mechanize.new
      page = agent.get uri
      industry = Industry.find_by uuid: uuid
      puts 'industry: '
      puts industry.name
      JSON(page.body)['modelessays'].each do |m|
        e = Experience.find_by title: m['title']
        if e.nil?
          pp m['title']
          Experience.create! industry_id: industry.id,
                             industry_name: industry.name,
                             title: m['title'],
                             sub_title: m['sub_title'],
                             content: m['content']

        end
      end
    end
  end


  desc 'export_benefits_to_file'
  task export_benefits_to_file: :environment do
    File.open('features/benefits.txt', 'w') do |file|
      Benefit.all.each do |b|
        b.name.split(/\、/).each { |w| file.puts w } if b.name
      end
    end
  end


  desc 'export_skills_to_file'
  task export_skills_to_file: :environment do
    File.open('features/skills.txt', 'w') do |file|
      Skill.all.each do |b|
        b.name.split(/[\、\，]/).each { |w| file.puts(w) if w } if b.name
      end
    end
  end


  desc 'export_categories_to_file'
  task export_categories_to_file: :environment do
    File.open('features/categories.txt', 'w') do |file|
      Category.all.each do |b|
        b.name.split(/[\、\，\/]/).each { |w| file.puts(w) if w } if b.name
      end
    end
  end


  desc 'export_interest_tags_to_file'
  task export_interest_tags_to_file: :environment do
    File.open('features/interest_tags.txt', 'w') do |file|
      InterestTag.all.each do |b|
        b.name.split(/[\、\，\/]/).each { |w| file.puts(w) if w } if b.name
      end
    end
  end



  desc 'export_industry_to_file'
  task export_industry_to_file: :environment do
    File.open('features/industry.txt', 'w') do |file|
      Industry.all.each do |b|
        b.name.split(/[\、\，\/]/).each { |w| file.puts(w) if w } if b.name
      end
    end
  end



  desc 'export_industry_experiences'
  task export_industry_experiences: :environment do
    File.open('features/industry_experiences.txt', 'w') do |file|
      Experience.all.map(&:industry_name).uniq.each do |name|
        file.puts name
        # b.industry_name.split(/[\、\，\/]/).uniq.each { |w| file.puts(w) if w } if b.industry_name
      end
    end
  end






end
