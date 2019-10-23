# typed: false

require 'draft'

RSpec.describe 'Draft' do
  let(:h1) { Heddle.new(1, 'green') }
  let(:h2) { Heddle.new(2) }
  let(:h3) { Heddle.new(3) }

  let(:unit1) { Unit.new([h1, h2]) }
  let(:unit2) { Unit.new([h3, h3]) }

  let(:block1) { Block.new(unit1, 1) }
  let(:block2) { Block.new(unit2, 1) }

  let(:profile) { Profile.new([block1, block2]) }

  let(:treadle1) { Treadle.new([1], 1) }
  let(:treadle2) { Treadle.new([2], 2) }
  let(:treadle3) { Treadle.new([3], 3) }

  let(:tieup) { Tieup.new([treadle1, treadle2, treadle3]) }
  let(:treadling) { [treadle1, treadle2, treadle3, treadle1, treadle2, treadle3] }
  let(:draft) { Draft.new(profile, tieup, treadling) }

  it 'can be initialized' do
    expect(draft.profile).to be_a Profile
    expect(draft.tieup).to be_a Tieup
    expect(draft.treadling).to be_a Array
  end

  it 'can figure out the threading' do
    expect(draft.threading).to eq [h1, h2, h3, h3]
  end

  context '.drawdown' do
    let(:drawdown) { draft.drawdown }

    it 'draws a pick for each treadle in the treadling' do
      expect(drawdown.length).to eq treadling.length
    end

    it 'draws all picks to be the length of the threading' do
      expect(drawdown.map(&:length).uniq.first).to eq draft.threading.length
    end

    it 'draws the correct color for each cell in a pick' do
      pick = drawdown[0]
      expect(pick[0]).to eq 'green'
      expect(pick[1]).to eq '#FFF'
      expect(pick[2]).to eq '#FFF'
      expect(pick[3]).to eq '#FFF'
    end

    it 'can render the drawdown as an svg' do
      expect(draft.render_drawdown).to include('<rect x="0" y="0" width="10" height="10" fill="green"/>')
    end
  end
end
