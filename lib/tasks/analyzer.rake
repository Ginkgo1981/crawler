namespace :analyzer do
  desc 'read from redis, fetch the content then analyze the content'
  task fetch_then_analyze: :environment do

    while(true)
      begin
        link_url = $redis.zrange('link_queue', 0, 0).first
        if link_url.present?
          $redis.zrem 'link_queue', link_url
          analyzer = Analyzer.factory(link_url)
          analyzer.get_content link_url
          puts "[analyzer] fetch_then_analyze link_url 0 '#{link_url}'"
        else
          puts "[analyzer] fetch_then_analyze empty 0 ''"
          sleep 10
        end
      rescue Exception => e
        puts "[analyzer] fetch_then_analyze error 0 ''"
      end
    end
  end
end
