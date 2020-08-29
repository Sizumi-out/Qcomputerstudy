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



# https://qiita.com/YuichiroMinato/items/5e85a96e9279247425f2

n = 2
modern_Bell = chain(
    n,
    put(2=>H),
    control(2, 1=>Rx(pi/2))
    # どうもこれはRXXじゃないらしい
)

apply!(zero_state(2), modern_Bell)

results = zero_state(2) |> modern_Bell |> r->measure(r, nshots = 1000)

hist = fit(Histogram, Int.(results), 0:2^n)

MBell_graff = bar(hist.edges[1] .- 0.5, hist.weights, legend =:none)

# GHZのグラフを一つにまとめて保存

A = plot(Bell_graff, GHZ3_graff, GHZ4_graff, MBell_graff, legend =:none)

path_png = "program/julia_code/plot_practice/entanglement.png"
path_svg = "program/julia_code/plot_practice/entanglement.svg"

savefig(A, path_svg)


# 角度の変化をアニメーションにできないか？
# 結論：yao.jlでRXXゲートが見つからない...

# アニメーションのインスタンス生成
anim = Animation()

for x = 0:0.05π:2π
    m_Bell = chain(
        2,
        put(2=>H),
        control(2, 1=>Rx(x))
    )

    apply!(zero_state(2), m_Bell)
    results = zero_state(2) |> m_Bell |> r->measure(r, nshots = 1000)
    hist = fit(Histogram, Int.(results), 0:4)
    MBell_plt = bar(hist.edges[1] .- 0.5, hist.weights, label = "θ = $x", ylims = (0, 1000))
    frame(anim, MBell_plt)
end

gif(anim,"anim_entangle.gif", fps = 10)
