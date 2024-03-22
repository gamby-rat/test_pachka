require 'sinatra'
require 'mysql2'

def db_connection
  db_config = {
    host: ENV['DB_HOST'], username: ENV['DB_USERNAME'], database: ENV['DB_NAME']
  }

  begin
    client = Mysql2::Client.new(db_config)
  rescue Mysql2::Error => e
    puts "Error connecting to master database: #{e.message}"
    db_config[:host] = ENV['DB_SLAVE_HOST']
    client = Mysql2::Client.new(db_config)
  end

  client
end

get '/' do
  client = db_connection

  begin
    client.query("INSERT INTO users (name) VALUES ('Test name')")
    results = client.query('SELECT * FROM users')

    content_type :json
    results.to_a.to_json
  rescue Mysql2::Error => e
    puts "Error executing query: #{e.message}"
    retry
  end
end