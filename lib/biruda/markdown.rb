module Biruda
  class Markdown # rubocop:disable Metrics/ClassLength
    VALID_TAGS = %i[
      h1 h2 h3 h4 h5 h6 t text i italics b bold s strikethrough br a link img image ic inline_code
      cb code_block line_break q quote hr horizontal_rule v video
      ol ordered_list ul unordered_list table
    ].freeze

    def initialize(_options = {})
      @document = ''
    end

    def self.create(options = {}, &block)
      new.build(options, &block)
    end

    def to_s
      @document
    end

    def build(options = {}, &block)
      @context = options[:context]
      instance_eval(&block) if block_given?
      self
    end

    def add(options = {}, &block)
      @context = options[:context]
      instance_eval(&block) if block_given?
      self
    end

    private

    def build_array_elements(array)
      array.each do |content|
        # This is a workaround because Ruby does not have lazy evaluation, so if the caller sends
        # a block with an element that is a tag, it will be evaluated before calling the method,
        # and will add that tag before the rest of the elements in the array
        if content.respond_to?(:call)
          content.call
        else
          @document << content
        end
      end
    end

    # Define h1 - h6
    (1..6).each do |number|
      define_method("h#{number}") do |content|
        return if content.nil?
        number.times { |_n| @document << '#' }
        @document << ' '
        @document << content
        @document << "\n"
      end
    end

    def text(content)
      if content.is_a?(Array)
        build_array_elements(content)
      elsif block_given?
        instance_eval(&block)
      else
        @document << content
      end
      br
    end

    def italics(content)
      if content.is_a?(Array)
        @document << '*'
        build_array_elements(content)
        @document << '*'
      else
        @document << "_#{content}_"
      end
    end

    def bold(content)
      if content.is_a?(Array)
        @document << '**'
        build_array_elements(content)
        @document << '**'
      else
        @document << "__#{content}__"
      end
    end

    def strikethrough(content)
      @document << '~~'
      if content.is_a?(Array)
        build_array_elements(content)
      else
        @document << content
      end
      @document << '~~'
    end

    def line_break
      @document << "\n"
    end

    def ordered_list(array)
      array.each_with_index do |content, idx|
        @document << "#{idx + 1}. #{content}\n"
      end
    end

    def unordered_list(array)
      array.each do |content|
        @document << "* #{content}\n"
      end
    end

    def link(text: nil, href: nil, title: nil)
      title = title.nil? ? '' : " \"#{title}\""
      @document << "[#{text}]"
      @document << "(#{href}#{title})\n" unless href.nil?
    end

    def img(text: nil, src: nil, title: nil)
      title = title.nil? ? '' : " \"#{title}\""
      @document << "![#{text}]"
      @document << "(#{src}#{title})\n" unless src.nil?
    end

    def inline_code(content)
      @document << "`#{content}`"
    end

    def code_block(content, language: nil)
      @document << "```#{language}\n#{content}\n```\n"
    end

    def quote(content)
      @document << "> #{content}\n"
    end

    def horizontal_rule
      @document << "\n---\n"
    end

    def table(headers:, content:)
      @document << headers.join(' | ')
      @document << "\n"
      @document << headers.map { '---' }.join(' | ')
      @document << "\n"
      process_table_content(content)
    end

    def process_table_content(content)
      content.each do |row|
        row.each_with_index do |cell, idx|
          if cell.respond_to?(:call)
            cell.call
          else
            @document << cell.to_s
          end
          @document << (idx < row.size - 1 ? ' | ' : "\n")
        end
      end
    end

    # rubocop:disable Metrics/ParameterLists
    def video(href:, src:, alt:, width: 240, height: 180, border: 10)
      @document << "<a href=\"#{href}\" target=\"_blank\">"
      @document << "<img src=\"#{src}\" alt=\"#{alt}\" width=\"#{width}\" height=\"#{height}\" "
      @document << "border=\"#{border}\" />"
      @document << "</a>\n"
    end
    # rubocop:enable Metrics/ParameterLists

    alias t text
    alias i italics
    alias b bold
    alias s strikethrough
    alias br line_break
    alias ol ordered_list
    alias ul unordered_list
    alias a link
    alias ic inline_code
    alias cb code_block
    alias q quote
    alias hr horizontal_rule
    alias v video
  end
end
