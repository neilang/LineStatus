source 'https://rubygems.org'

ruby '2.1.0'

gem 'rake'
gem 'dotenv', '~> 0.11.1', require: 'dotenv'

gem 'slim'
gem 'activerecord', '~> 4.1.0', require: 'active_record'

group :development, :test do
  gem 'sqlite3'
end

group :test do
  gem 'rspec', group: 'test'
  gem 'rack-test', require: 'rack/test', group: 'test'
end

group :production do
  gem 'pg', '~> 0.17.1'
  gem 'thin', '~> 1.6.2'
end

gem 'padrino', '0.12.1'
