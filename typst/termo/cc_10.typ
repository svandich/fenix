#set page(width: auto, height: auto, margin: (x: 0.5em, y: 0.3em), fill: none)
#set text(fill: rgb("#e6edf3"), size: 13pt)

$ Q_N = 1 / V^N integral...integral d^3 q_1 ... d^3 q_N exp(-beta sum_(i<j) u(r_(i j))) $

#pagebreak()

$ f(r) = exp(-beta u(r)) - 1 quad quad exp(-beta u(r)) = 1 + f(r) $

#pagebreak()

$ Q_N approx 1 + N^2 / (2V) integral 4 pi r^2 f(r) thin d r $

#pagebreak()

$ P = (N k_B T) / V - (N^2 k_B T) / V^2 dot.op pi integral_0^infinity r^2 (1 - e^(-beta u(r))) thin d r $
