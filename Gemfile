source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.0.2'
gem 'mysql2'
gem 'redis'
gem 'redis-namespace'
gem 'puma', '~> 3.0'
gem 'mechanize'
gem 'nokogiri'
gem 'listen'
gem 'selenium'
gem 'selenium-webdriver'
gem 'elasticsearch'
# gem 'tesseract-ocr'
gem 'faraday'
gem 'whenever', :require => false
group :development, :test do
  gem 'pry'
  gem 'pry-nav'
  gem 'pry-rails'
  gem 'annotate', git: 'https://github.com/ctran/annotate_models.git'
end

group :development do
  gem 'mina', '~> 0.3.8'
  gem 'mina-sidekiq'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end
