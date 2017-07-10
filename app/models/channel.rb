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

  def enqueue_links
    analyzer = self.analyzer.constantize.new
    link_urls = analyzer.get_links(self.url)
    link_urls.each do |url|
      cache_url = url.scan(/91job/) ? url.split(/\//)[-1] : url
      if $redis.sismember 'cache_urls', cache_url
        puts "[channel] enqueue hit-cache 0 '#{cache_url}'"
      else
        $redis.sadd 'cache_urls', cache_url #cache
        $redis.zadd 'link_queue', 100, url #queue
        puts "[channel] enqueue #{site.name} 0 '#{url}'"
      end
    end
  end

end
