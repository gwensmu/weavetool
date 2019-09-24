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

  sig { params(face: Integer, middle: Integer, reverse: Integer, block: Block).returns(T::Array[T::Array[Integer]]) }
  def self.treadling_for(face, middle, reverse, block)
    pick1 = [odd_shaft_for(face, block)]
    pick2 = [even_shaft_for(face, block)]
    pick3 = [shafts_for(face, block), odd_shaft_for(middle, block)]
    pick4 = [shafts_for(face, block), even_shaft_for(middle, block)]
    pick5 = [shafts_except(T.must(even_shaft_for(reverse, block)), block)]
    pick6 = [shafts_except(T.must(odd_shaft_for(reverse, block)), block)]

    [pick1, pick2, pick3, pick4, pick5, pick6].map(&:flatten).map(&:sort)
  end

  sig { params(shafts_for_a: T::Array[T::Array[Integer]], shafts_for_b: T::Array[T::Array[Integer]]).returns(T::Array[Treadle]) }
  def self.treadling(shafts_for_a, shafts_for_b)
    treadling = []
    shafts_for_b.reverse # weave block b "upside down"

    shafts_for_a.each_with_index do |shafts, i|
      pick = (shafts + shafts_for_b[i])
      treadling << Treadle.new(pick, i + 1)
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
