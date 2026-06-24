#set page(width: auto, height: auto, margin: (x: 0.5em, y: 0.3em), fill: none)
#set text(fill: rgb("#e6edf3"), size: 13pt)

$ I_"enc"(r) = integral_0^r J_0 (1 - r'/R) 2 pi r' d r'
  = 2 pi J_0 integral_0^r (r' - r'^2/R) d r'
  = 2 pi J_0 (r^2/2 - r^3/(3R))
  = pi J_0 r^2 (1 - 2r/(3R)) $

#pagebreak()

$ arrow(B)_"plano" = cases(
  +mu_0/2 K hat(x) & "encima del plano",
  -mu_0/2 K hat(x) & "debajo del plano"
) $

#pagebreak()

$ arrow(B)_"solenoide" = cases(
  mu_0 n I hat(z) & r < R,
  bold(0)          & r > R
) $

#pagebreak()

$ arrow(f) / A = arrow(K) times arrow(B)_"ext" = n_2 I_2 hat(phi) times mu_0 n_1 I_1 hat(z)
  = mu_0 n_1 n_2 I_1 I_2 hat(rho) $

#pagebreak()

$ I_"net" = J_0 (pi R^2 - pi b^2) \
  arrow(B)(D) = mu_0 I_"net" / (2 pi D) hat(phi) \
  F/L = mu_0 I I_"net" / (2 pi D) $
