class SlackService
  def self.alert text
    # url = 'https://hooks.slack.com/services/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'
    # payload = {
    #     text: "#{Time.now.to_s} - #{text}"
    # }
    # res = Faraday.post url,JSON.generate(payload)
    # puts "[SlackService] alert res: #{res.body}"
    puts "[SlackService] alert res: #{Time.now.to_s} - #{text}"
  end
end