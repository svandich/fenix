#set page(width: auto, height: auto, margin: (x: 0.5em, y: 0.3em), fill: none)
#set text(fill: rgb("#e6edf3"), size: 13pt)

$ Xi(T, V, mu) = sum_(N=0)^infinity sum_r e^(beta(mu N - E_(N,r))) = sum_(N=0)^infinity z^N Z_N $

#pagebreak()

$ p V = k_B T ln Xi quad quad angle.l N angle.r = z (diff ln Xi)/(diff z) quad quad angle.l E angle.r = -(diff ln Xi)/(diff beta) bar_(z,V) $

#pagebreak()

$ overline(n)_"FD" (epsilon) = 1/(e^(beta(epsilon - mu)) + 1) quad quad overline(n)_"BE" (epsilon) = 1/(e^(beta(epsilon - mu)) - 1) $

#pagebreak()

$ T_F = epsilon_F / k_B quad quad T_"BE" = (2 pi planck.reduce^2)/(m k_B) lr((N \/ (V zeta(3\/2))))^(2\/3) $
