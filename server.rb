require 'sinatra'
require 'csv'
require_relative "app/models/television_show"

set :views, File.join(File.dirname(__FILE__), "app/views")

get '/television_shows' do
  @shows = []
  CSV.foreach('television-shows.csv', headers: true, header_converters: :symbol) do |row|
    shows = row.to_hash
    @shows << shows
  end

  erb :index
end

get '/television_shows/new' do
  erb :new
end

post '/television_shows/new' do
  
  @error = nil
  if params.has_value?('')
    @error = "Please fill in all required fields"
    @user_input = params
    erb :new
  else
    CSV.open('television-shows.csv', 'a') do |file|
      title = params["title"]
      network = params["network"]
      starting_year = params["starting_year"]
      synopsis = params["synopsis"]
      genre = params["genre"]
      data = [title, network, starting_year, synopsis, genre]
      file.puts(data)
    end
    redirect '/television_shows'
  end
end
