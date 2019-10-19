# typed: strict
require 'sorbet-runtime'
require 'victor'
require_relative './entities'

# Creates a visual schematic of our loom setup
# and weaving plan
class Draft
  extend T::Sig
  attr_reader :profile, :tieup, :treadling

  sig { params(profile: Profile, tieup: Tieup, treadling: T::Array[Treadle]).void }
  def initialize(profile, tieup, treadling)
    @profile = profile
    @tieup = tieup 
    @treadling = treadling
    @drawdown = drawdown
  end

  sig { params(weft_color: String).returns(T::Array[T::Array[String]]) }
  def drawdown(weft_color = '#FFF')
    acc = []

    @treadling.each do |treadle|
      row = []
      shafts = Set.new(treadle.shafts)
      threading.each do |heddle|
        shafts.include?(heddle.shaft) ? row.append(heddle.color) : row.append(weft_color)
      end
      acc.append(row)
    end

    acc
  end

  sig {returns(T::Array[Heddle])}
  def threading
    @profile.blocks.map(&:units).flatten.map(&:threading).reduce([]) { |u1, u2| u1 + u2 }
  end

  def render_drawdown
    svg = Victor::SVG.new width: 500, height: 500, style: { background: '#ddd' }

    rows = @drawdown
    vertical_repeats = rows[0].length / threading.length
    svg.build do
      vertical_repeats.times do |v|
        rows.each_with_index do |row, i|
          row.each_with_index.each do |cell, y|
            rect x: 10*i, y: (10*y) + (10*v), width: 10, height: 10, fill: cell
          end
        end
      end
    end
    svg.save 'draft'
  end
end
