# typed: strict
require 'sorbet-runtime'

require 'entities'
require 'draft'

# Helpers for drafting triple weave
module TripleWeave
  extend T::Sig
  CLOTH_ONE = T.let(1, Integer)
  CLOTH_TWO = T.let(2, Integer)
  CLOTH_THREE = T.let(3, Integer)

  sig { params(face: Integer, middle: Integer, reverse: Integer, block_a: Block, block_b: Block).returns(T::Array[Treadle]) }
  def self.treadling_for(face, middle, reverse, block_a, block_b)
    pick1 = [odd_shaft_for(face, block_a), shafts_except(T.must(even_shaft_for(face, block_b)), block_b)]
    pick2 = [even_shaft_for(face, block_a), shafts_except(T.must(odd_shaft_for(face, block_b)), block_b)]
    pick3 = [shafts_for(face, block_a), odd_shaft_for(middle, block_a), odd_shaft_for(middle, block_b), shafts_for(reverse, block_b)]
    pick4 = [shafts_for(face, block_a), even_shaft_for(middle, block_a), even_shaft_for(middle, block_b), shafts_for(reverse, block_b)]
    pick5 = [shafts_except(T.must(even_shaft_for(reverse, block_a)), block_a), odd_shaft_for(reverse, block_b)]
    pick6 = [shafts_except(T.must(odd_shaft_for(reverse, block_a)), block_a), even_shaft_for(reverse, block_b)]

    treadling = []
    [pick1, pick2, pick3, pick4, pick5, pick6].each_with_index do |p, i|
      shafts = p.flatten.sort
      treadling << Treadle.new(shafts, i + 1)
    end
    treadling
  end

  sig { params(cloth: Integer, block: Block).returns(T.nilable(Integer)) }
  def self.odd_shaft_for(cloth, block)
    shafts_for(cloth, block).select(&:odd?).first
  end

  sig { params(cloth: Integer, block: Block).returns(T.nilable(Integer)) }
  def self.even_shaft_for(cloth, block)
    shafts_for(cloth, block).select(&:even?).first
  end

  sig { params(cloth: Integer, block: Block).returns(T::Array[Integer]) }
  def self.shafts_for(cloth, block)
    heddles(block).select { |h| h.cloth == cloth }.map(&:shaft)
  end

  sig { params(shaft: Integer, block: Block).returns(T::Array[Integer]) }
  def self.shafts_except(shaft, block)
    heddles(block).map(&:shaft).reject { |i| i == shaft }
  end

  # could we define this as a collection method? we'd need
  # to define the blocks class inheriting from enumerable, fun to learn
  sig { params(block: Block).returns(T::Array[Heddle]) }
  def self.heddles(block)
    block.units.map(&:threading).flatten
  end
end
