# typed: false

require 'triple_weave'

RSpec.describe 'TripleWeave' do
  let(:yellow) { 'yellow' }
  let(:green) { 'green' }
  let(:blue) { 'blue' }

  let(:block_a) do
    h1 = Heddle.new(1, yellow, TripleWeave::CLOTH_ONE)
    h2 = Heddle.new(2, yellow, TripleWeave::CLOTH_ONE)
    h3 = Heddle.new(3, green, TripleWeave::CLOTH_TWO)
    h4 = Heddle.new(4, green, TripleWeave::CLOTH_TWO)
    h5 = Heddle.new(5, blue, TripleWeave::CLOTH_THREE)
    h6 = Heddle.new(6, blue, TripleWeave::CLOTH_THREE)

    unit = Unit.new([h1, h3, h5, h2, h4, h6])

    Block.new(unit, 1)
  end

  let(:block_b) do
    h7 = Heddle.new(7, yellow, TripleWeave::CLOTH_ONE)
    h8 = Heddle.new(8, yellow, TripleWeave::CLOTH_ONE)
    h9 = Heddle.new(9, green, TripleWeave::CLOTH_TWO)
    h10 = Heddle.new(10, green, TripleWeave::CLOTH_TWO)
    h11 = Heddle.new(11, blue, TripleWeave::CLOTH_THREE)
    h12 = Heddle.new(12, blue, TripleWeave::CLOTH_THREE)

    unit = Unit.new([h7, h9, h11, h8, h10, h12])

    Block.new(unit, 1)
  end

  it 'can figure out the treadling for supplied cloth order' do
    pick1 = Treadle.new([5, 7, 8, 9, 10, 12], 1)
    pick2 = Treadle.new([6, 7, 8, 9, 10, 11], 2)
    pick3 = Treadle.new([1, 5, 6, 8, 9, 10], 3)
    pick4 = Treadle.new([2, 5, 6, 7, 9, 10], 4)
    pick5 = Treadle.new([1, 2, 3, 5, 6, 10], 5)
    pick6 = Treadle.new([1, 2, 4, 5, 6, 9], 6)

    picks_for_a = TripleWeave.treadling_for(TripleWeave::CLOTH_THREE,
                                             TripleWeave::CLOTH_ONE,
                                             TripleWeave::CLOTH_TWO,
                                             block_a)
    picks_for_b = TripleWeave.treadling_for(TripleWeave::CLOTH_TWO,
                                             TripleWeave::CLOTH_ONE,
                                             TripleWeave::CLOTH_THREE,
                                             block_b).reverse
    expect(picks_for_a[0].treadle.shafts).to match [5]
    expect(picks_for_b[0].treadle.shafts).to match [7, 8, 9, 10, 12]

    expect(picks_for_a[1].treadle.shafts).to match [6]
    expect(picks_for_b[1].treadle.shafts).to match [7, 8, 9, 10, 11]

    expect(picks_for_a[2].treadle.shafts).to match [1, 5, 6]
    expect(picks_for_b[2].treadle.shafts).to match [8, 9, 10]

    expect(picks_for_a[3].treadle.shafts).to match [2, 5, 6]
    expect(picks_for_b[3].treadle.shafts).to match [7, 9, 10]

    expect(picks_for_a[4].treadle.shafts).to match [1, 2, 3, 5, 6]
    expect(picks_for_b[4].treadle.shafts).to match [10]

    expect(picks_for_a[5].treadle.shafts).to match [1, 2, 4, 5, 6]
    expect(picks_for_b[5].treadle.shafts).to match [9]

    treadling = TripleWeave.treadling(picks_for_a, picks_for_b)

    expect(treadling[0].shafts).to match pick1.shafts
    expect(treadling[1].shafts).to match pick2.shafts
    expect(treadling[2].shafts).to match pick3.shafts
    expect(treadling[3].shafts).to match pick4.shafts
    expect(treadling[4].shafts).to match pick5.shafts
    expect(treadling[5].shafts).to match pick6.shafts
  end

  it 'can find shafts for a given color in a block' do
    shafts = TripleWeave.shafts_for(TripleWeave::CLOTH_THREE, block_a)
    expect(shafts).to eq [5, 6]
  end

  it 'every shaft but the provided shaft in a block' do
    shafts = TripleWeave.shafts_except(10, block_b)
    expect(shafts).to contain_exactly(7, 8, 9, 11, 12)
  end

  it 'can find the shaft to treadle for the odd pick of a given color in a given block' do
    expect(TripleWeave.odd_shaft_for(TripleWeave::CLOTH_ONE, block_a)).to eq 1
  end

  it 'can find the shaft to treadle for the even pick of a given color in a given block' do
    expect(TripleWeave.even_shaft_for(TripleWeave::CLOTH_ONE, block_a)).to eq 2
  end
end
