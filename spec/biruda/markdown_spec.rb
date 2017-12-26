require 'spec_helper'

describe Biruda::Markdown do
  describe '::VALID_TAGS' do
    it 'contains all valid tags' do
      expect(described_class::VALID_TAGS)
        .to match_array %i[
          h1 h2 h3 h4 h5 h6 i italics b bold s strikethrough ol ordered_list ul unordered_list a
          link img image ic inline_code cb code_block table q quote hr t text horizontal_rule br
          line_break v video
        ]
    end
  end

  describe '.create' do
    let(:complete_block) do
      proc {
        h1 'H1'
        h2 'H2'
        h3 'H3'
        h4 'H4'
        h5 'H5'
        h6 'H6'
        t [
          'Emphasis, aka italics, with ',
          -> { i 'underscores' },
          '.'
        ]
        br
        text [
          'Strong emphasis, aka bold, with ',
          -> { bold 'underscores' },
          '.'
        ]
        t [
          'Combined emphasis with ',
          lambda {
            b [
              'asterisks and ',
              -> { italics 'underscores' }
            ]
          },
          '.'
        ]
        s 'Scratch this.'
        br
        link text: "I'm an inline-style link", href: 'https://www.google.com'
        a text: "I'm an inline-style link with title",
          href: 'https://www.google.com',
          title: "Google's Homepage"
        t [
          'Or leave it empty and use the ',
          -> { a text: 'link text itself' },
          '.'
        ]
        img(
          text: 'alt text',
          src: 'https://github.com/adam-p/markdown-here/raw/master/src/common/images/icon48.png',
          title: 'Logo Title Text'
        )
        br
        code_block "s = \"Python syntax highlighting\"\nprint s", language: 'python'
        ic 'python example'
        br
        quote 'Blockquotes are very handy in email to emulate reply text.'
        q 'This line is part of the same quote.'
        hr
        table(
          headers: %w[Markdown Less Pretty],
          content: [
            [-> { i 'Still' }, -> { ic 'renders' }, -> { b 'nicely' }],
            [1, 2, 3]
          ]
        )
        br
        video(
          href: 'http://www.youtube.com/watch?feature=player_embedded&v=YOUTUBE_VIDEO_ID_HERE',
          src: 'http://img.youtube.com/vi/YOUTUBE_VIDEO_ID_HERE/0.jpg',
          alt: 'IMAGE ALT TEXT HERE',
          width: 240,
          height: 180,
          border: 10
        )
        br
        ol [
          'First ordered list item',
          'Another item'
        ]
        br
        ul [
          'Unordered list use asterisks',
          'This is a second unordered element'
        ]
      }
    end

    it 'returns an HTML object' do
      expect(described_class.create.is_a?(described_class)).to be_truthy
    end

    context 'when sending a block' do
      it 'creates the document correctly' do
        builder = described_class.create(&complete_block)
        expect(builder.to_s).to eq(File.read('./spec/support/fixtures/example.md'))
      end
    end
  end
end
