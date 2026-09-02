#set page(width: auto, height: auto, margin: (x: 0.5em, y: 0.3em), fill: none)
#set text(fill: rgb("#e6edf3"), size: 13pt)

$ Z = (P overline(V))/(R T) = overline(V)/(overline(V) - b) - a/(R T overline(V)) = 1/(1 - b slash overline(V)) - a/(R T overline(V)) $

#pagebreak()

$ Z = 1 + (b - a/(R T)) 1/overline(V) + (b/overline(V))^2 + (b/overline(V))^3 + dots $

#pagebreak()

$ Z = 1 + 1/(R T) (b - a/(R T)) P + a/(R T)^3 (2b - a/(R T)) P^2 + dots $

#pagebreak()

$ lr((partial Z)/(partial P))_(T, P -> 0) = 1/(R T) (b - a/(R T)) quad cases(
  > 0 quad "domina el tamaño molecular " (b),
  < 0 quad "dominan las fuerzas atractivas " (a)
) $

#pagebreak()

$ b - a/(R T_B) = 0 quad => quad T_B = a/(R b) $

#pagebreak()

$ lr((partial P)/(partial overline(V)))_(T_c) = 0 quad quad lr((partial^2 P)/(partial overline(V)^2))_(T_c) = 0 $

#pagebreak()

$ overline(V)_c = 3b quad quad P_c = a/(27 b^2) quad quad T_c = (8a)/(27 R b) quad quad Z_c = (P_c overline(V)_c)/(R T_c) = 3/8 $

#pagebreak()

$ a = 3 P_c overline(V)_c^2 = (27 R^2 T_c^2)/(64 P_c) quad quad b = overline(V)_c/3 = (R T_c)/(8 P_c) $

#pagebreak()

$ pi = P/P_c quad quad tau = T/T_c quad quad phi = overline(V)/overline(V)_c $

#pagebreak()

$ pi = (8 tau)/(3 phi - 1) - 3/phi^2 quad quad Z = Z(tau, pi) $
