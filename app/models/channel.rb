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
    # analyzer = self.analyzer.constantize.new
    analyzer = Analyzer.factory(self.url)
    link_urls = analyzer.get_links(self.url)
    link_urls.each do |url|
      cache_url =
          if url.scan(/91job.*job/).present?
            "91job-job-#{url.split(/\//)[-1]}"
          elsif url.scan(/91job.*campus/).present?
            "91job-campus-#{url.split(/\//)[-1]}"
          elsif url.scan(/91wllm.*job/).present?
            "91wllm-job-#{url.split(/\//)[-1]}"
          elsif url.scan(/91wllm.*campus/).present?
            "91wllm-campus-#{url.split(/\//)[-1]}"
          else
            url
          end
      if $redis.sismember 'cache_urls', cache_url
        puts "[crawler] enqueue hit-cache 0 '#{cache_url}'"
      else
        $redis.sadd 'cache_urls', cache_url #cache
        $redis.zadd 'link_queue', 100, url #queue
        puts "[crawler] enqueue #{self.name.to_s} 0 '#{url}'"
      end
    end
  end

end
