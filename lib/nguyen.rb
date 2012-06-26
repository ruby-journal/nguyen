require 'nguyen/fdf'
require 'nguyen/xfdf'
require 'nguyen/pdf'
require 'nguyen/pdftk_wrapper'

module Nguyen
  # shorthand for Nguyen::PdftkWrapper.new(...)
  def self.new(*args)
    PdftkWrapper.new(*args)
  end
end
