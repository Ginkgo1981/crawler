# == Schema Information
#
# Table name: channels
#
#  id            :integer          not null, primary key
#  site_id       :integer
#  name          :string(255)
#  url           :string(255)
#  status        :string(255)
#  last_crawl_at :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  analyzer      :string(255)
#

class Channel < ApplicationRecord
  belongs_to :site


  def get_and_enqueue_links
    analyzer = self.analyzer.constantize.new
    link_urls = analyzer.get_links(self.url)
    link_urls.each do |url|
      if $redis.sismember 'link_urls', url
        puts "[channel] enqueue-link exsit url #{url}"
      else
        $redis.sadd 'link_urls', url #cache
        $redis.zadd 'link_queue', 100, url #queue
        puts "[channel] enqueue-link succ url #{url}"
      end
    end
  end






end
