# encoding: UTF-8
version = File.read(File.expand_path('../NGUYEN_VERSION', __FILE__)).strip

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'nguyen'
  s.version     = version
  s.summary     = 'Fill out PDF forms by XFDF/FDF via pdftk.'
  s.description = 'Forms for Nguyên is Ruby library that could merge PDF fields by XFDF/FDF via pdftk.'
  
  s.authors     = 'Trung Lê'
  s.email       = 'joneslee85@gmail.com'
  s.homepage    = 'http://github.com/joneslee85/nguyen'

  s.files        = Dir['{lib}/**/*.rb', 'LICENSE', '*.rdoc']
  s.require_path = 'lib'
  s.requirements << 'pdtk 1.44.1 or newer'
  s.required_ruby_version     = '>= 1.8.7'
  s.required_rubygems_version = '>= 1.3.6'

  s.add_dependency 'nokogiri', '~> 1.5.5'
end