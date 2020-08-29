using Yao

function GHZ_1(times::Integer)
    n = 3
    GHZ_3circuit_a = chain(
        n,  # 3qubits
        put(1=>H),
        control(1,2=>X),
        control(2,3=>X),
    )

    apply!(zero_state(3), GHZ_3circuit_a)

    results = zero_state(3) |> GHZ_3circuit_a |> r->measure(r, nshots = times)

    hist = fit(Histogram, Int.(results), 0:2^n)

    bar(hist.edges[1] .- 0.5, hist.weights, legend =:none)
end

@time GHZ_1(2000)
# 0.001782 seconds (4.15 k allocations: 256.414 KiB)
# 0.001406 seconds (4.15 k allocations: 256.195 KiB


function GHZ_2(times)
    CHZ_3circuit = chain(
        n,  # 3qubits
        put(1=>X), # 1: Xgate
        repeat(H, 2:3),
        control(2, 1=>X), # 2:control-bit, 1:target-bit
        control(3, 1=>X),
        repeat(H, 1:3), # Hgate, 1:4-qubits
    )

    apply!(zero_state(3), CHZ_3circuit)

    results = zero_state(3) |> CHZ_3circuit |> r->measure(r, nshots = times)

    hist = fit(Histogram, Int.(results), 0:2^n)

    bar(hist.edges[1] .- 0.5, hist.weights, legend =:none)
end

@time GHZ_2(2000)
# 0.087389 seconds (49.97 k allocations: 2.543 MiB)
# 0.006637 seconds (4.27 k allocations: 262.695 KiB)