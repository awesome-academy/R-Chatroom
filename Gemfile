source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.6.1"

gem "rails", "~> 5.2.2", ">= 5.2.2.1"
gem "mysql2", ">= 0.4.4", "< 0.6.0"
gem "puma", "~> 3.11"
gem "jbuilder", "~> 2.5"
gem "bcrypt", "~> 3.1.7"
gem "bootsnap", ">= 1.1.0", require: false
gem "rack-cors"
gem "config"
gem "webpacker", "~> 4.x"
gem "pagy"
gem "simple_token_authentication"
gem "ransack"
gem "cancancan"

group :development, :test do
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "faker"
  gem "rspec-rails"
  gem "shoulda-matchers"
  gem "factory_bot_rails"
end

group :development do
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
end
