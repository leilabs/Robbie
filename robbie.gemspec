# -*- encoding: utf-8 -*-
require File.expand_path('../lib/robbie/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['Ben Poile', 'Josh Trommel']
  gem.email         = ['benp51@outlook.com', 'joshtrommel@gmail.com']
  gem.description   = 'Media Information at your Fingertips'
  gem.summary       = 'TV, Movie, Music, and Book Information ready when are you are'
  gem.homepage      = 'https://github.com/BenP51/robbie'

  gem.files         = `git ls-files`.split($\)
  gem.executables   = ['robbie']
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = 'robbie'
  gem.require_paths = ['lib']
  gem.version       = Robbie::VERSION
  gem.licenses       = ['MIT']

  gem.add_development_dependency "bundler", "~> 1.6"
  gem.add_development_dependency "rake", '~> 0'

  gem.add_dependency 'rainbow', '~> 2.0'
  gem.add_dependency 'kat', '~> 2.0'
  gem.add_dependency 'canistreamit', '~> 0.0.2'
  gem.add_dependency 'http', '~> 1.0', '>= 1.0.2'
  gem.add_dependency 'goodreads', '~> 0.4.3'
  gem.add_dependency 'bitly', '~> 0.10.4'
end
