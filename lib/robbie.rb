# commands: stream, movie, tv, music, book
require_relative 'robbie/version'
require_relative 'robbie/command'
require 'rainbow'

module Robbie
  module_function #ily

  def run(*args)
    if args.empty?
      Command.help
    else
      process args
    end
  end

  def process(*args)
    @args = args.first
    @first = @args.shift

    case @first
    when 'search' then Command.search(@args)
    when 'info' then Command.info(@args)
    when 'version', '--version' then puts Robbie::E_VERSION
    when 'help', '--help' then Command.help(@args)
    else puts "robbie: '#{@first}' is not a robbie command. See 'robbie --help'."
    end
  end

end
