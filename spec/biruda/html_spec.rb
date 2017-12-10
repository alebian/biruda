require 'spec_helper'

describe Biruda::HTML do
  let(:complete_block) do
    proc {
      head do
        title 'This is a HTML DSL test'
        script src: 'mypage.com/mysuper.js'
      end
      body do
        h1 'HEADING'
        p [
          'This is part of my ',
          -> { b 'paragraph' },
          ' Wow'
        ]
      end
    }
  end

  describe '::VALID_TAGS' do
    it 'contains all valid tags' do
      expect(described_class::VALID_TAGS)
        .to match_array %i[
          head title body a abbr acronym address applet area article aside audio b base basefont
          bdo big blockquote br button canvas caption center cite code col colgroup datalist dd del
          details dfn dialog dir div dl dt em embed fieldset figcaption figure font footer form
          frameset header hr html i iframe img input ins kbd label legend li link main map mark
          menuitem meta meter nav noframes noscript object ol optgroup option output p param pre
          progress q rp rt ruby s samp script section select small source span strike strong style
          summary sup table tbody td textarea tfoot th thead time tr track tt u ul var video wbr p
          sub bdi frame menu h1 h2 h3 h4 h5 h6
        ]
    end
  end

  describe '.create' do
    it 'returns an HTML object' do
      expect(described_class.create.is_a?(described_class)).to be_truthy
    end

    context 'when sending a block' do
      it 'creates the document correctly' do
        builder = described_class.create(&complete_block)
        expect(builder.to_s).to eq(
          '<!DOCTYPE html><html><head><title>This is a HTML DSL test</title>' \
          '<script src="mypage.com/mysuper.js" /></head><body><h1>HEADING</h1>' \
          '<p>This is part of my <b>paragraph</b> Wow</p></body></html>'
        )
      end
    end
  end
end
