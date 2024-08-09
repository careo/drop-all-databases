# frozen_string_literal: true

require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem 'mysql2'
end

require 'mysql2'

# Define MySQL credentials
MYSQL_USER = ENV['MYSQL_USER'] || 'root'
MYSQL_PASSWORD = ENV['MYSQL_PASSWORD'] || ''
MYSQL_HOST = ENV['MYSQL_HOST'] || 'localhost'

# Create a client to connect to MySQL
client = Mysql2::Client.new(
  host: MYSQL_HOST,
  username: MYSQL_USER,
  password: MYSQL_PASSWORD
)

# Define system databases to exclude
EXCLUDED_DATABASES = %w[information_schema mysql performance_schema sys]

# Get the list of databases
databases = client.query('SHOW DATABASES').map { |row| row['Database'] }

# Drop each database that is not in the excluded list
databases.each do |db|
  unless EXCLUDED_DATABASES.include?(db)
    puts "Dropping database: #{db}"
    client.query("DROP DATABASE `#{db}`")
  end
end

puts 'All non-system databases have been deleted.'
