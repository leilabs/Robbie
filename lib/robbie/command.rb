require_relative 'request'
require_relative 'search'
# Request.movie('movie title')
# Request.tv('tv show')
# Request.actor('actor name')
# Request.book('book name')

module Command
  module_function

  def search(*args)
    @args = args.first
    @command = @args.shift

    if @command.nil? then help end

    case @command
    when 'movie' then Search.movie(@args)
    when 'tv' then Search.tv(@args)
    when 'actor' then Search.actor(@args)
    else help end
  end

  def info(*args)
    @args = args.first
    @command = @args.shift

    if @command.nil? then help end

    case @command
    when 'movie' then Request.movie(@args)
    when 'tv' then Request.tv(@args)
    when 'actor' then Request.actor(@args)
    when 'book' then Request.book(@args)
    when 'song' then Request.song(@args)
    when 'album' then Request.album(@args)
    when 'artist' then Request.artist(@args)
    when 'id' then Request.id(@args) # currently only works for movie and tv show
    else help end
  end

  def help(*args)
    unless args.empty?
      @args = args.first
      @command = @args.first
    end

    if @command.nil?
      advice = {
        search:   'searches the query and returns the first 3 results',
        info:     'provides extensive information on the query (ID)',
        version:  'returns the current version',
        help:     'return this help menu'
      }

      puts "usage: robbie [command] [arguments]"
      advice.map do |key, value|
        puts "#{key}\t\t#{value}"
      end
      exit
    else

      info = {
        search: {
          command: 'search',
          example: 'robbie search movies "Pulp Fiction"',
          description: 'searches the query and returns the first 3 results'
        },
        info: {
          command: 'info',
          example: 'robbie info tt0110912',
          description: 'provides extensive information on the query (ID)'
        },
        version: {
          command: 'version',
          example: 'robbie version',
          description: 'returns the current version',
        },
        help: {
          command: 'help',
          example: 'robbie help search',
          description: 'return this help menu. if an optional command parameter is provided, a description and exmaple is returned'
        }
      }

      if info.has_key? @command.to_sym
        symInfo = info[@command.to_sym]
        puts Rainbow("robbie #{symInfo[:command]}\n").white.bg(:black)
        puts "Example: $ #{symInfo[:example]}\n"
        puts "Description: #{symInfo[:description]}"
      else
        puts "No manual entry for #{@command}"
      end

    end
  end

end
