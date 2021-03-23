# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pmd/gem_version.rb'

Gem::Specification.new do |spec|
  spec.name = 'danger-pmd'
  spec.version = Pmd::VERSION
  spec.authors = ['Mathieu Rul']
  spec.email = ['mathroule@gmail.com']
  spec.description = 'A Danger plugin for PMD.'
  spec.summary = 'A Danger plugin for PMD (Programming Mistake Detector), see https://pmd.github.io.'
  spec.homepage = 'https://github.com/mathroule/danger-pmd'
  spec.license = 'MIT'

  spec.files = `git ls-files`.split($/)
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'danger-plugin-api', '~> 1.0'
  spec.add_runtime_dependency 'oga', '~> 2.15'

  # General ruby development
  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 13.0'

  # Testing support
  spec.add_development_dependency 'codecov', '~> 0.5.1'
  spec.add_development_dependency 'rspec', '~> 3.10.0'

  # Linting code and docs
  spec.add_development_dependency 'rubocop', '~> 1.11.0'
  spec.add_development_dependency 'rubocop-rake', '~> 0.5.1'
  spec.add_development_dependency 'rubocop-rspec', '~> 2.2.0'
  spec.add_development_dependency 'yard', '~> 0.9.26'

  # Makes testing easy via `bundle exec guard`
  spec.add_development_dependency 'guard', '~> 2.16.2'
  spec.add_development_dependency 'guard-rspec', '~> 4.7.3'

  # If you want to work on older builds of ruby
  spec.add_development_dependency 'listen', '~> 3.0.8'

  # This gives you the chance to run a REPL inside your tests
  # via:
  #
  #    require 'pry'
  #    binding.pry
  #
  # This will stop test execution and let you inspect the results
  spec.add_development_dependency 'pry', '~> 0.14.0'
end
