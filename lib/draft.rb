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
      pick = []
      shafts = Set.new(treadle.shafts)
      threading.each do |heddle|
        shafts.include?(heddle.shaft) ? pick.append(heddle.color) : pick.append(weft_color)
      end
      acc.append(pick)
    end

    acc
  end

  sig {returns(T::Array[Heddle])}
  def threading
    @profile.blocks.map(&:units).flatten.map(&:threading).reduce([]) { |u1, u2| u1 + u2 }
  end

  def render_drawdown
    svg = Bundler::Settings::Mirror::SVG.new width: 500, height: 500, style: { background: '#ddd' }

    picks = @drawdown
    vertical_repeats = picks[0].length / threading.length
    svg.build do
      vertical_repeats.times do |v|
        picks.each_with_index do |pick, i|
          pick.each do |p|
            col = p.shaft - 1
            rect x: 10*i, y: (10*col) + (10*v), width: 10, height: 10, fill: color
          end
        end
      end
    end
    svg.save 'draft'
  end
end
