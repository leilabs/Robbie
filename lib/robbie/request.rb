require 'json'
require 'http'
require 'uri'
require 'time'
require 'goodreads'
require 'canistreamit'
require 'bitly'
require 'kat'

module Request
  module_function

  Bitly.use_api_version_3

  def id(id)
    @id = URI.escape(id.shift)
    @res = HTTP.get("http://www.omdbapi.com/?i=#{@id}")
    @json = JSON.parse(@res)

    puts <<-EOS
    Title: \t\t #{@json["Title"]}
    Plot:  \t\t #{@json["Plot"]}
    Poster: \t #{@json["Poster"]}
    Actors: \t #{@json["Actors"]}
    Rating: \t\t #{@json["imdbRating"]}
    EOS
  end

  def artist(args) # to do
    @artist = URI.escape(args.shift)
    @res = HTTP.get("http://ws.audioscrobbler.com/2.0/?method=artist.getInfo&artist=#{@artist}&api_key=0a7d3b25ed857f679eba1a353e98a658&format=json").body
    @json = JSON.parse(@res)

    puts @json['artist']['bio']['summary']
  end

  def song(args) # to do
    # Requires track title and artist name
    @song = URI.escape(args.shift)
    @artist = URI.escape(args.shift)
    @res = HTTP.get("http://ws.audioscrobbler.com/2.0/?method=track.getInfo&track=#{@song}&artist=#{@artist}&api_key=0a7d3b25ed857f679eba1a353e98a658&format=json").body
    @json = JSON.parse(@res)

    # hax
    if @year = @json['track']['wiki'].nil?
      @year = "Not Available"
    else
      @year = @json['track']['wiki']['published']
    end

    puts <<-EOS
    Title: \t#{@json['track']['name']}
    Artist: \t#{@json['track']['artist']['name']}
    Year: \t#{@year}
    Duration: \t#{@json['track']['duration'].to_i/1000} seconds
    EOS
  end

  def album(args) # works, sort of
    # Requires artist and album
    @album = URI.escape(args.shift)
    @artist = URI.escape(args.shift)
    @res = HTTP.get("http://ws.audioscrobbler.com/2.0/?method=album.getInfo&artist=#{@artist}&album=#{@album}&api_key=0a7d3b25ed857f679eba1a353e98a658&format=json").body
    @json = JSON.parse(@res)

    puts <<-EOS
    Title: \t#{@json['album']['name']}
    Artist: \t#{@json['album']['artist']}
    Year: \t#{@json['album']['wiki']['published']}
    Tracks: \t
    EOS

    # this is the messiest shit i've ever seen :-)
    @json['album']['tracks']['track'].length.times do |i|
      puts "\t##{i+1}:\t#{@json['album']['tracks']['track'][i]['name']}"
    end
  end

  def movie(t)
    title = t.shift
    parsedTitle = URI.escape(title)

    bitly = Bitly.new('benp51', 'R_886e9ca24b25c1e91d66f5c6379568a9')
    client = Canistreamit::Client.new
    kitkat = Kat.quick_search(title)

    canistreamit = client.search_and_query(title, ["streaming"])

    res = HTTP.get("http://www.omdbapi.com/?t=#{parsedTitle}&y=&plot=short&r=json")
    omdbData = JSON.parse(res)

    puts <<-EOS
    Title: \t#{omdbData["Title"]}
    Plot: \t#{omdbData["Plot"]}
    Director: \t#{omdbData["Director"]}
    Poster: \t#{bitly.shorten(omdbData["Poster"]).short_url}
    Actors: \t#{omdbData["Actors"]}
    Rating: \t#{omdbData["imdbRating"]}
    EOS

    if(canistreamit[0]["availability"]["streaming"].empty?)
      puts "Stream: \tNot Available"
    else
      puts "Stream: "
      canistreamit[0]["availability"]["streaming"].each do |service|
      puts "\t#{service[1]['friendlyName']}\t#{bitly.shorten(service[1]["direct_url"]).short_url}"
    end

  end
  end

  def tv (t)
    title = t.shift
    parsedTitle = URI.escape(title)
    
    bitly = Bitly.new('benp51', 'R_886e9ca24b25c1e91d66f5c6379568a9')
    client = Canistreamit::Client.new
    canistreamit = client.search_and_query(title, ["streaming"])

    res = HTTP.get("http://www.omdbapi.com/?t=#{parsedTitle}&type=series&plot=short&r=json")
    omdbData = JSON.parse(res)

    puts <<-EOS
    Title:\t\t#{omdbData["Title"]}
    Plot:\t\t#{omdbData["Plot"]}
    Poster:\t\t#{bitly.shorten(omdbData["Poster"]).short_url}
    Actors:\t\t#{omdbData["Actors"]}
    Rating:\t\t#{omdbData["imdbRating"]}
    EOS
  end

  def actor (args)
    name = URI.escape(args.first)
    res = HTTP.get("http://www.myapifilms.com/imdb/idIMDB?name=#{name}&token=8e26a029-8cf1-4dd7-89bd-889bf5e74cbd&format=json&language=en-us&filmography=1&exactFilter=0&limit=1&bornDied=1&starSign=0&uniqueName=0&actorActress=0&actorTrivia=0&actorPhotos=0&actorVideos=0&salary=0&spouses=0&tradeMark=0&personalQuotes=0&starMeter=0")
    myApiFilms = JSON.parse(res)

    dob = Time.parse(myApiFilms["data"]["names"][0]["dateOfBirth"])
    now = Time.now.utc.to_date
    age = now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)

    apiFilmsShort = myApiFilms["data"]["names"][0]
    films = apiFilmsShort["filmographies"][0]["filmography"]
    puts "Name:\t\t#{apiFilmsShort["name"]}"
    puts "Age:\t\t#{age} years"
    print "Filmography:\t"
    10.times do |i|
      str = films[i]["year"]
      if str =~ /\d/
        if(i == 9)
          print "#{films[i]["title"]} (#{films[i]["year"][1..-1]})."
        else
          print "#{films[i]["title"]} (#{films[i]["year"][1..-1]}), "
        end
      else
        if(i == 9)
          print "#{films[i]["title"]} (TBD)."
        else
          print "#{films[i]["title"]} (TBD), "
        end
      end
    end
    puts "\nBirthday:\t#{apiFilmsShort["dateOfBirth"]}"
  end

  def book (title) # GR Ruby gem auto formats the query to be readable
    # file = File.read('key.json')
    # keys = JSON.parse(file)
    title = title.first
    client = Goodreads.new(:api_key => 'oSMwxqaPNr0o1PYs2Jddg') # keys["goodreads"]["public"] # i fucking hate code dude i s2g
    book = client.book_by_title(title)

    puts <<-EOS
    Title: #{book.title}
    Publisher: #{book.publisher}
    Author: #{book.authors.author[0]['name']}
    EOS
  end

end
