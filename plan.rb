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

unit = Unit.new([h1, h3, h5, h2, h4, h6])

block_a = Block.new(unit, 1)

h7 = Heddle.new(7, yellow, TripleWeave::CLOTH_ONE)
h8 = Heddle.new(8, yellow, TripleWeave::CLOTH_ONE)
h9 = Heddle.new(9, green, TripleWeave::CLOTH_TWO)
h10 = Heddle.new(10, green, TripleWeave::CLOTH_TWO)
h11 = Heddle.new(11, blue, TripleWeave::CLOTH_THREE)
h12 = Heddle.new(12, blue, TripleWeave::CLOTH_THREE)

unit = Unit.new([h7, h9, h11, h8, h10, h12])

block_b = Block.new(unit, 1)

TripleWeave.treadling_plan(TripleWeave::CLOTH_THREE,
TripleWeave::CLOTH_ONE,
TripleWeave::CLOTH_TWO, block_a, block_b)