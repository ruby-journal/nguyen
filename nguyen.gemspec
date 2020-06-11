# encoding: UTF-8
$:.push File.expand_path('../lib', __FILE__)
require 'nguyen/version'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'nguyen'
  s.version     = Nguyen::VERSION.dup
  s.summary     = 'Fill out PDF forms by XFDF/FDF via pdftk.'
  s.description = 'Forms for Nguyên is Ruby library that could merge PDF fields by XFDF/FDF via pdftk.'

  s.authors     = 'Trung Lê'
  s.email       = 'trung.le@ruby-journal.com'
  s.homepage    = 'http://github.com/ruby-journal/nguyen'
  s.license     = %q{MIT}

  s.files        = Dir['{lib}/**/*.rb', 'LICENSE', '*.md']
  s.require_path = 'lib'
  s.requirements << 'pdtk 1.44.1 or newer'
  s.required_ruby_version     = '>= 2.5.0'

  s.add_runtime_dependency 'nokogiri', '~> 1.5'
  s.add_development_dependency 'minitest'
end
