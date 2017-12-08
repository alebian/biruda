require 'spec_helper'

describe Biruda do
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

  describe '.create_html' do
    it 'returns an HTML object' do
      expect(described_class.create_html.is_a?(described_class::HTML)).to be_truthy
    end

    context 'when sending a block' do
      it 'creates the document correctly' do
        builder = described_class.create_html(&complete_block)
        expect(builder.to_s).to eq(
          '<!DOCTYPE html><html><head><title>This is a HTML DSL test</title>' \
          '<script src="mypage.com/mysuper.js" /></head><body><h1>HEADING</h1>' \
          '<p>This is part of my <b>paragraph</b> Wow</p></body></html>'
        )
      end
    end
  end
end
