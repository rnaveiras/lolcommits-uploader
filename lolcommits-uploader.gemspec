# -*- encoding: utf-8 -*-
require File.expand_path('../lib/lolcommits-uploader/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Raúl Naveiras"]
  gem.email         = ["rnaveiras@gmail.com"]
  gem.description   = %q{lolcommits uploader to s3}
  gem.summary       = %q{lolcommits uploader to s3}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "lolcommits-uploader"
  gem.require_paths = ["lib"]
  gem.version       = Lolcommits::Uploader::VERSION
  
  gem.add_dependency 'fog'
  gem.add_dependency 'rmagick'
  gem.add_dependency 'git'
  gem.add_dependency 'progressbar'
  
end
