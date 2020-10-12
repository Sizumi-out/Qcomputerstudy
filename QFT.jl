# https://tutorials.yaoquantum.org/dev/generated/quick-start/2.qft-phase-estimation/
using Yao

#= define block A:
 第一量子ビットに対する演算
=#
A(i, j) = control(i, j=>shift(2π/(1<<(i-j+1))))
# shift: Create a ShiftGate with phase θ
# <<: bitshift
# example: 1 << 4   julia>16

R4 = A(4,1)
R4(5) # qubit数指定
mat(R4(5)) # 行列表示

# repeat on different qubit
# put a Hadamard gate to i-th qubit to construct i-th B block.
B(n, k) = chain(n, j==k ? put(k=>H) : A(j, k) for j in k:n)
# n: qubit数指定

qft(n) = chain(B(n, k) for k in 1:n)
qft(4)


# Wrap QFT to an external block

struct QFT{N} <: PrimitiveBlock{N} end
#  PrimitiveBlock{N} <: AbstractBlock{N}
QFT(n::Int) = QFT{n}()

circuit(::QFT{N}) where N = qft(N)

YaoBlocks.mat(::Type{T}, x::QFT) where T = mat(T, circuit(x))
YaoBlocks.print_block(io::IO, x::QFT{N}) where N = print(io, "QFT($N)")


# use FFT to simulate the results of QFT (like cheating)
using FFTW, LinearAlgebra

function YaoBlocks.apply!(r::ArrayReg, x::QFT)
    α = sqrt(length(statevec(r)))
    invorder!(r)
    lmul!(α, ifft!(statevec(r)))
    return r
end

r = rand_state(5)
r1 = r |> copy |> QFT(5)
r2 = r |> copy |> circuit(QFT(5))
r1 ≈ r2

QFT(5)'