source 'https://rubygems.org'

ruby '2.1.0'

gem 'rake', '~> 10.3.1'
gem 'dotenv', '~> 0.11.1', require: 'dotenv'

gem 'slim', '~> 2.0.2'
gem 'activerecord', '~> 4.1.0', require: 'active_record'

group :development, :test do
  gem 'sqlite3', '~> 1.3.9'
end

group :test do
  gem 'rspec', '~> 2.14.1'
  gem 'rack-test', '~> 0.6.2', require: 'rack/test'
end

group :production do
  gem 'pg', '~> 0.17.1'
  gem 'thin', '~> 1.6.2'
end

gem 'padrino', '0.12.1'
