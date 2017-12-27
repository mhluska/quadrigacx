require 'spec_helper'

describe QuadrigaCX::Coin do
  describe '#valid?' do
    it 'returns true for valid coin type' do
      coin = QuadrigaCX::Coin::BITCOIN
      expect(described_class.valid?(coin)).to be true
    end

    it 'returns false for invalid coin type' do
      coin = 'DummyCoin'
      expect(described_class.valid?(coin)).to be false
    end
  end
end