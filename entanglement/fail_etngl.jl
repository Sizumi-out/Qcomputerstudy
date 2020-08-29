# https://qiita.com/YuichiroMinato/items/5e85a96e9279247425f2

n = 2
modern_Bell = chain(
    n,
    put(2=>H),
    control(2, 1=>Rx(pi/2)) # どうもこれはRXXじゃないらしい
)

apply!(zero_state(2), modern_Bell)

results = zero_state(2) |> modern_Bell |> r->measure(r, nshots = 1000)

hist = fit(Histogram, Int.(results), 0:2^n)

MBell_graff = bar(hist.edges[1] .- 0.5, hist.weights, legend =:none)

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