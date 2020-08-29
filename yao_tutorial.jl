Pkg.add Yao

Pkg.add StatsBase

using Yao

# circuit
# https://tutorials.yaoquantum.org/dev/generated/quick-start/1.prepare-ghz-state/assets/ghz4.png

circuit = chain(
    4,  # 4qubits
    put(1=>X), # 1: Xgate
    repeat(H, 2:4),
    control(2, 1=>X), # 2:control-bit, 1:target-bit
    control(4, 3=>X),
    control(3, 1=>X),
    control(4, 3=>X),
    repeat(H, 1:4), # Hgate, 1:4-qubits
)

# explanation

put(4, 1=>X)
?=> #  Construct a Pair object with type Pair{typeof(x), typeof(y)}
# Pair型：イテレートできる構造体みたいなやつ

put(4, (1,2)=>swap(2,1,2))
# 最初の引数はbit数?
# swap:  swap(n, loc1, loc2)
#   Create a n-qubit Swap gate which swap loc1 and loc2.

put(1=>X)

put(1=>X)(4)


repeat(H, 2:4)

control(4, 2, 1=>X)

control(2, 1=>X)
# (n -> control(n, 2, 1 => X))
# n qubits, CNT:2, TAR:1

typeof(circuit)

# 下2つは同じ？
zero_state(4)
ArrayReg{bit"0000"}
# ArrayRegistar

apply!(zero_state(4), circuit)

results = zero_state(4) |> circuit |> r->measure(r, nshots = 1000)
?|> # A |> B :: AをBに代入
typeof(results)

using StatsBase, Plots

# fit気になる
hist = fit(Histogram, Int.(results), 0:16)
# 0:16: 4bit なので、2^4 = 16

bar(hist.edges[1] .- 0.5, hist.weights, legend =:none)
# bar:棒グラフ
bar(hist.edges[1], hist.weights, legend =:none)
# hist.edges[1] .- 0.5::x軸の目盛りの位置ずらしてるっぽい
bar(hist.edges[1],legend =:none)
# hist.weightsがないと、添字をプロットし始める