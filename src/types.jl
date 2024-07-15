# abstract types
abstract type AbstractBinaryFloat{Bits, SigBits} <: AbstractFloat end

abstract type AkoUnsignedFloat{Bits, SigBits} <: AbstractBinaryFloat{Bits, SigBits} end
abstract type AkoSignedFloat{Bits, SigBits} <: AbstractBinaryFloat{Bits, SigBits} end

# const concrete types

const μSafeEncode = Base.UInt16
const μSafeValue  = Base.Float64

const μEncode = Base.UInt8
const μValue  = Base.Float32

# concrete types

mutable struct SimpleFloat{Bits, SigBits} <: AbstractBinaryFloat{Bits, SigBits}
    encodings::SizedVector{Bits, μEncode}
    values::SizedVector{Bits, μValue}
end

function SimpleFloat(bitwidth, precision)
    n = 2^bitwidth
    encodings = map(μEncode, 1:nvalues(Bits))
    values = zeros(μValue, n)
    for (idx, encoded) in enumerate(encodings)
        values[idx] = decode_value(Bits, SigBits, encoded)
    end
    SimpleFloat{bitwidth, precision}(Tuple(encodings), Tuple(values))
end

decode_value(Bits, SigBits, encoded) = 0x01

