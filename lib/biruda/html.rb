module Biruda
  class HTML
    # The default HTML version of this class is 5
    EMPTY_TAG_CLOSER = ' />'.freeze
    VALID_TAGS = %i[
      head title body a abbr acronym address applet area article aside audio b base basefont bdi
      bdo big blockquote br button canvas caption center cite code col colgroup datalist dd del
      details dfn dialog dir div dl dt em embed fieldset figcaption figure font footer form frame
      frameset header hr html i iframe img input ins kbd label legend li link main map mark menu
      menuitem meta meter nav noframes noscript object ol optgroup option output p param pre
      progress q rp rt ruby s samp script section select small source span strike strong style sub
      summary sup table tbody td textarea tfoot th thead time tr track tt u ul var video wbr p
      h1 h2 h3 h4 h5 h6
    ].freeze

    def initialize
      @page = '<!DOCTYPE html>'
    end

    def self.create(options = {}, &block)
      new.build(options, &block)
    end

    def to_s
      @page
    end

    def build(options = {}, &block)
      @context = options[:context]
      html(&block)
      self
    end

    def build_tag(options = {}, &block)
      @context = options[:context]
      instance_eval(&block)
      self
    end

    private

    VALID_TAGS.each do |tag|
      define_method(tag) do |*args, &block|
        tag(tag, *args, &block)
      end
    end

    OpeningTag = Struct.new(:tag, :ending?)

    def built_tag_is_empty(name, content, attributes, block_given)
      opening_tag = "<#{name}"

      attributes.each { |key, value| opening_tag << " #{key}=\"#{value}\"" }

      opening_tag << if content.nil? && !block_given
                       EMPTY_TAG_CLOSER
                     else
                       '>'
                     end

      @page << opening_tag
      opening_tag.include?(EMPTY_TAG_CLOSER)
    end

    def build_array_elements(array)
      array.each do |cont|
        # This is a workaround because Ruby does not have lazy evaluation, so if the caller sends
        # a block with an element that is a tag, it will be evaluated before calling the method,
        # and will add that tag before the rest of the elements in the array
        if cont.respond_to?(:call)
          cont.call
        else
          @page << cont
        end
      end
    end

    def tag(name, content = nil, attributes = {}, &block)
      content, attributes = adapt_tag_params(content, attributes)

      return if built_tag_is_empty(name, content, attributes, block_given?)

      if content.is_a?(Array)
        build_array_elements(content)
      elsif block_given?
        instance_eval(&block)
      else
        @page << content
      end

      @page << "</#{name}>"
    end

    def adapt_tag_params(content, attributes)
      # In case the caller does something like `script src: 'some js'`
      return [nil, content] if content.is_a?(Hash)
      [content, attributes]
    end
  end
end
