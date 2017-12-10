require 'biruda/version'
require 'biruda/html'

module Biruda
  def self.create_html(options = {}, &block)
    HTML.create(options, &block)
  end
end
