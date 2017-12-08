require 'spec_helper'

describe Biruda::VERSION do
  let(:version) { Biruda::VERSION }

  it 'is the correct version' do
    expect(version).to eq('0.1.0')
  end
end
