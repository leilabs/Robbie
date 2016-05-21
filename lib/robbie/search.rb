require 'json'
require 'http'
require 'uri'
require 'time'

module Search
  module_function

  def movie(title)
    if title.empty?
      puts "You need to specify a movie to query"
      exit
    end
    title = URI.escape(title.first)
    url = "http://www.omdbapi.com/?type=movie&r=json&s="+title
    omdbData = JSON.parse(HTTP.get('http://www.omdbapi.com/?type=movie&r=json&s='+title).body)
    puts "- #{omdbData["Search"][0]["Title"]} (#{omdbData["Search"][0]["Year"]}) - imdb.com/title/#{omdbData["Search"][0]["imdbID"]}"
    puts "- #{omdbData["Search"][1]["Title"]} (#{omdbData["Search"][1]["Year"]}) - imdb.com/title/#{omdbData["Search"][1]["imdbID"]}"
    puts "- #{omdbData["Search"][2]["Title"]} (#{omdbData["Search"][2]["Year"]}) - imdb.com/title/#{omdbData["Search"][2]["imdbID"]}"
  end

  def tv (title)
    if title.nil?
      puts "You need to specify a TV show to query"
      exit
    end
    title = URI.escape(title.first)
    omdbData = JSON.parse(HTTP.get('http://www.omdbapi.com/?type=series&r=json&s='+title).body)
    puts "- #{omdbData["Search"][0]["Title"]} (#{omdbData["Search"][0]["Year"]}) - imdb.com/title/#{omdbData["Search"][0]["imdbID"]}"
    puts "- #{omdbData["Search"][1]["Title"]} (#{omdbData["Search"][1]["Year"]}) - imdb.com/title/#{omdbData["Search"][1]["imdbID"]}"
    puts "- #{omdbData["Search"][2]["Title"]} (#{omdbData["Search"][2]["Year"]}) - imdb.com/title/#{omdbData["Search"][2]["imdbID"]}"
  end

  def actor (name)
    if name.nil?
      puts "You need to specify an actor/actress to query"
      exit
    end
    name = URI.escape(name.first)
    myApiFilms = JSON.parse(HTTP.get("http://www.myapifilms.com/imdb/idIMDB?name=#{name}&token=8e26a029-8cf1-4dd7-89bd-889bf5e74cbd&format=json&language=en-us&limit=1&bornDied=1").body)

    dob = Time.parse(myApiFilms["data"]["names"][0]["dateOfBirth"])
    now = Time.now.utc.to_date
    age = now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
    puts "- #{myApiFilms["data"]["names"][0]["name"]} (Age: #{age}) /#{myApiFilms["data"]["names"][0]["idIMDB"]}"
  end
end
