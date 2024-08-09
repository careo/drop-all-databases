# frozen_string_literal: true

require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem 'mysql2', require: true
  gem 'dotenv', require: true
end

Dotenv.load
Dotenv.load '.env.local'

client = Mysql2::Client.new(
  host: ENV['MYSQL_HOST'],
  username: ENV['MYSQL_USER'],
  password: ENV['MYSQL_PASSWORD'],
)

keepers = %w[information_schema mysql performance_schema sys].freeze

databases = client.query('SHOW DATABASES').collect { |row| row['Database'] }

databases.each do |db|
  next if keepers.include?(db)

  puts "Dropping database: #{db}"
  client.query("DROP DATABASE `#{db}`")
end

puts 'All non-system databases have been deleted.'
