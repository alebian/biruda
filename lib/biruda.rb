require 'biruda/version'
require 'biruda/html'
require 'biruda/markdown'

module Biruda
  def self.create_html(options = {}, &block)
    HTML.create(options, &block)
  end
end
