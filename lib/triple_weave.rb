# typed: strict
require 'sorbet-runtime'

require 'erb'

require_relative 'entities'
require_relative 'draft'

# Helpers for drafting triple weave
module TripleWeave
  extend T::Sig
  CLOTH_ONE = T.let(1, Integer)
  CLOTH_TWO = T.let(2, Integer)
  CLOTH_THREE = T.let(3, Integer)

  sig {params(face: Integer, middle: Integer, reverse: Integer, block_a: Block, block_b: Block).returns(T::Array[Pick])}
  def self.treadling_plan(face, middle, reverse, block_a, block_b)
    # {face: face, middle: middle, reverse: reverse, block: block}
    a_picks = treadling_for(face, middle, reverse, block_a)
    b_picks = treadling_for(face, middle, reverse, block_b)

    treadling(a_picks, b_picks.reverse)
  end

  sig { params(face: Integer, middle: Integer, reverse: Integer, block: Block).returns(T::Array[Pick]) }
  def self.treadling_for(face, middle, reverse, block)
    pick1_shafts = [odd_shaft_for(face, block)]
    pick2_shafts = [even_shaft_for(face, block)]
    pick3_shafts = [shafts_for(face, block), odd_shaft_for(middle, block)]
    pick4_shafts = [shafts_for(face, block), even_shaft_for(middle, block)]
    pick5_shafts = [shafts_except(T.must(even_shaft_for(reverse, block)), block)]
    pick6_shafts = [shafts_except(T.must(odd_shaft_for(reverse, block)), block)]

    picks = []

    [pick1_shafts, pick2_shafts, pick3_shafts, pick4_shafts, pick5_shafts, pick6_shafts].each_with_index do |shafts, i|
      picks << Pick.new(Treadle.new(shafts, i+1), block.thread(i).color)
    end

    picks
  end

  sig { params(picks_for_a: T::Array[Pick], picks_for_b: T::Array[Pick]).returns(T::Array[Pick]) }
  def self.treadling(picks_for_a, picks_for_b)
    treadling = []
    picks_for_b.reverse # weave block b "upside down"

    picks_for_a.each_with_index do |pick, i|
      combined_shafts = (pick.shafts + T.must(picks_for_b[i]).shafts)
      weft_color = assign_weft_color(i, pick.color, T.must(picks_for_b[0]).color)
      treadling << Pick.new(Treadle.new(combined_shafts, i + 1), weft_color)
    end
    treadling
  end

  sig { params(shaft_index: Integer, color_a: String, color_b: String).returns(String) }
  def self.assign_weft_color(shaft_index, color_a, color_b)
    shaft_index <= 3 ? color_a : color_b
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
