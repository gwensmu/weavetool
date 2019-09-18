# typed: true
require 'sorbet-runtime'

require 'entities'

# Creates a visual schematic of our loom setup
# and weaving plan
class Draft
  attr_reader :profile, :tieup, :treadling
  
  def initialize(profile, tieup, treadling)
    @profile = profile # type Profile
    @tieup = tieup # type Tieup
    @treadling = treadling # type [Treadle]
  end

  def drawdown
    acc = []

    @treadling.each do |treadle|
        pick = []
        shafts = Set.new(treadle.shafts)
        threading.each do |heddle|
            shafts.include?(heddle.shaft) ? pick.append(heddle.color) : pick.append('#FFF')
        end
        acc.append(pick)
    end

    acc
  end

  def threading
    @profile.blocks.map(&:units).flatten.map(&:threading).reduce([]) { |u1, u2| u1 + u2 }
  end
end

