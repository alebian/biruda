require 'biruda/version'
require 'biruda/html'

module Biruda
  def self.create_html(&block)
    HTML.create(&block)
  end
end
