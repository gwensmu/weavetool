# typed: strict

require 'sorbet-runtime'

# A heddle holds a single thread of a given color, and sits on a shaft
# We denote which "cloth" its in for multiweaves
class Heddle
  extend T::Sig

  sig { returns(Integer) }
  attr_reader :shaft, :cloth

  sig { returns(String) }
  attr_reader :color

  sig { params(shaft: Integer, color: String, cloth: Integer).void }
  def initialize(shaft, color = '#000', cloth = 1)
    @shaft = T.let(shaft, Integer)
    @color = T.let(color, String)
    @cloth = T.let(cloth, Integer)
  end
end

# A unit is the basic element of a  block
# which decribes one  repeat of the threading pattern
class Unit
  extend T::Sig
  
  sig { returns(T::Array[Heddle]) }
  attr_reader :threading

  sig { params(heddles: T.untyped).void }
  def initialize(heddles)
    @threading = T.let(heddles, T::Array[Heddle])
  end

  sig { returns(Integer) }
  def length
    @threading.length
  end
end

# A collection of identical units
class Block
  extend T::Sig

  sig { returns(Unit) }
  attr_reader :unit

  sig { params(unit: T.untyped, count: T.untyped).void }
  def initialize(unit, count)
    @unit = T.let(unit, Unit)
    @count = T.let(count, Integer)
  end

  sig { returns(T::Array[Unit]) }
  def units
    acc = []
    @count.times { acc.append @unit }
    acc
  end
end

# A profile lists units (including repeats)
# in order of threading, from left to right
class Profile
  extend T::Sig

  sig { returns(T::Array[Block]) }
  attr_reader :blocks
  
  sig { params(blocks: T::Array[Block]).void }
  def initialize(blocks)
    @blocks = T.let(blocks, T::Array[Block])
  end
end

# Denote which shafts are attached to a given treadle
class Treadle
  extend T::Sig

  sig { returns(Integer) }
  attr_reader :position

  sig { returns(T::Array[Integer]) }
  attr_reader :shafts
  
  sig { params(shafts: T::Array[Integer], position: Integer).void }
  def initialize(shafts, position)
    @shafts = T.let(shafts, T::Array[Integer])
    @position = T.let(position, Integer)
  end
end

# A collection of treadles
class Tieup
  extend T::Sig

  sig { returns(T::Array[Treadle]) }
  attr_reader :treadles
  
  sig { params(treadles: T::Array[Treadle]).void }
  def initialize(treadles)
    @treadles = T.let(treadles, T::Array[Treadle])
  end
end

# A treadling + a yarn color
class Pick
  extend T::Sig

  sig { returns(Treadle) }
  attr_reader :treadle

  sig { returns(String) }
  attr_reader :color

  sig {params(treadle: T.untyped, color: T.untyped).void}
  def initialize(treadle, color)
    @treadle = T.let(treadle, Treadle)
    @color = T.let(color, String)
  end

  sig {returns(T::Array[Integer])}
  def shafts 
    @treadle.shafts
  end
end
