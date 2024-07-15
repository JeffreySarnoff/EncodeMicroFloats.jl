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
    encodings::SizedVector{2^Bits, μEncode}
    values::SizedVector{2^Bits, μValue}

    function SimpleFloat{Bits, SigBits}()
        n = 2^Bits
        encodings = Tuple(map(μEncode, 1:n)) # final
        values = zeros(μValue, n)
        for (idx, encoded) in enumerate(encodings)
            values[idx] = evaluate(Bits, SigBits, encoded)
        end
        SimpleFloat{Bits, SigBits}(encodings, Tuple(values))
    end
end

n_values(x) = x >= 0 ? 2^x : 1//2^x

function SimpleFloat(Bits, SigBits)
    encodings = map(μEncode, 1:n_values(Bits))
    values = map(μFloatValue, 1:n_values(Bits))
    SimpleFloat{Bits, SigBits}(encodings, values)
end