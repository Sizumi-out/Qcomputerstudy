using Yao
using Plots
using StatsBase # fit関数に用いる

n = 2
Bell_circuit = chain(
    n,
    put(2=>H),
    control(2, 1=>X),
)

apply!(zero_state(2), Bell_circuit)

results = zero_state(2) |> Bell_circuit |> r->measure(r, nshots = 1000)

hist = fit(Histogram, Int.(results), 0:2^n)

Bell_graff = bar(hist.edges[1] .- 0.5, hist.weights, legend =:none)


# https://www.youtube.com/watch?v=agLUyLqPWqM
n = 3
GHZ_3circuit_a = chain(
    n,  # 3qubits
    put(1=>H),
    control(1,2=>X),
    control(2,3=>X),
)

apply!(zero_state(3), GHZ_3circuit_a)

results = zero_state(3) |> GHZ_3circuit_a |> r->measure(r, nshots = 1000)

hist = fit(Histogram, Int.(results), 0:2^n)

GHZ3_graff = bar(hist.edges[1] .- 0.5, hist.weights, legend =:none)


GHZ_4circuit = chain(
    4,  # 4qubits
    put(1=>X), # 1: Xgate
    repeat(H, 2:4),
    control(2, 1=>X), # 2:control-bit, 1:target-bit
    control(4, 3=>X),
    control(3, 1=>X),
    control(4, 3=>X),
    repeat(H, 1:4), # Hgate, 1:4-qubits
)

apply!(zero_state(4), GHZ_4circuit)

results = zero_state(4) |> GHZ_4circuit |> r->measure(r, nshots = 1000)

hist = fit(Histogram, Int.(results), 0:2^4)

GHZ4_graff = bar(hist.edges[1] .- 0.5, hist.weights, legend =:none)

# GHZのグラフを一つにまとめて保存

A = plot(Bell_graff, GHZ3_graff, GHZ4_graff, legend =:none)

path_png = "program/julia_code/plot_practice/entanglement.png"
path_svg = "program/julia_code/plot_practice/entanglement.svg"

savefig(A, path_svg)