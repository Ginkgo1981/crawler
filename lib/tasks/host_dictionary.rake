namespace :host_dictionary do

  # host
  desc 'host'
  task university: :environment do
    File.open('features/host_json.txt', 'w') do |file|
      ss = Site.all.map{|s| {name: s.name, host: URI(s.url).host}}
      ss.each do |s|
        puts s[:name]
        file.puts "#{s[:name]},#{s[:host]}"
      end
    end
  end

end
