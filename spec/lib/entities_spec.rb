# typed: false

# fix imports
require '/Users/gwensmuda/dev/weavetool/lib/entities.rb'

RSpec.describe 'Heddle' do
  it 'can be initialized' do
    h = Heddle.new(1)
    expect(h.shaft).to be 1
    expect(h.color).to eq '#000'
  end
end

RSpec.describe 'Unit' do
  let(:h1) { Heddle.new(1) }
  let(:h2) { Heddle.new(2) }

  it 'can be initialized' do
    u = Unit.new([h1, h2])
    expect(u.threading).to eq [h1, h2]
  end

  it 'reports its length' do
    u = Unit.new([h1, h2])
    expect(u.length).to eq 2
  end
end

RSpec.describe 'Block' do
  let(:h1) { Heddle.new(1) }
  let(:h2) { Heddle.new(2) }

  let(:unit1) { Unit.new([h1, h2]) }

  it 'can be initialized' do
    b = Block.new(unit1, 2)
    expect(b.units).to eq [unit1, unit1]
  end
end

RSpec.describe 'Profile' do
  let(:h1) { Heddle.new(1) }
  let(:h2) { Heddle.new(2) }
  let(:h3) { Heddle.new(3) }

  let(:unit1) { Unit.new([h1, h2]) }
  let(:unit2) { Unit.new([h3, h3]) }

  let(:block1) { Block.new(unit1, 1) }
  let(:block2) { Block.new(unit2, 1) }

  it 'can be initialized' do
    p = Profile.new([block1, block2])
    expect(p.blocks).to eq [block1, block2]
  end
end

RSpec.describe 'Treadle' do
  it 'can be initialized' do
    tr = Treadle.new([1, 2], 1)
    expect(tr.shafts).to eq [1, 2]
    expect(tr.position).to be 1
  end
end

RSpec.describe 'Tieup' do
  let(:treadle) { Treadle.new([1], 1) }

  it 'can be initialized' do
    tieup = Tieup.new([treadle])
    expect(tieup.treadles).to eq [treadle]
  end
end
