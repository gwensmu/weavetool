require_relative './lib/entities'
require_relative './lib/triple_weave'

yellow = 'yellow'
green = 'green'
blue = 'blue'

h1 = Heddle.new(1, yellow, TripleWeave::CLOTH_ONE)
h2 = Heddle.new(2, yellow, TripleWeave::CLOTH_ONE)
h3 = Heddle.new(3, green, TripleWeave::CLOTH_TWO)
h4 = Heddle.new(4, green, TripleWeave::CLOTH_TWO)
h5 = Heddle.new(5, blue, TripleWeave::CLOTH_THREE)
h6 = Heddle.new(6, blue, TripleWeave::CLOTH_THREE)

unit = Unit.new([h1, h2, h3, h4, h5, h6])
block_a = Block.new(unit, 1)

h7 = Heddle.new(7, yellow, TripleWeave::CLOTH_ONE)
h8 = Heddle.new(8, yellow, TripleWeave::CLOTH_ONE)
h9 = Heddle.new(9, green, TripleWeave::CLOTH_TWO)
h10 = Heddle.new(10, green, TripleWeave::CLOTH_TWO)
h11 = Heddle.new(11, blue, TripleWeave::CLOTH_THREE)
h12 = Heddle.new(12, blue, TripleWeave::CLOTH_THREE)

unit = Unit.new([h7, h9, h11, h8, h10, h12])
block_b = Block.new(unit, 1)

@plans = []

# treadling plan needs to allow for what cloth is on top in what block
@plans << TripleWeave.treadling_plan(TripleWeave::CLOTH_THREE,
                           TripleWeave::CLOTH_ONE,
                           TripleWeave::CLOTH_TWO, block_a, block_b)

@plans << TripleWeave.treadling_plan(TripleWeave::CLOTH_TWO,
TripleWeave::CLOTH_ONE,
TripleWeave::CLOTH_THREE, block_a, block_b)
                           
@plans << TripleWeave.treadling_plan(TripleWeave::CLOTH_ONE,
TripleWeave::CLOTH_THREE,
TripleWeave::CLOTH_TWO, block_a, block_b)

template_path = File.join(File.dirname(__FILE__), "./views/triple_weave_treadling.erb")
plan = ERB.new(File.read(template_path)).result binding

open('plan.html', 'w') { |f|
  f.puts plan
}