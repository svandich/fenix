#set page(width: auto, height: auto, margin: (x: 0.5em, y: 0.3em), fill: none)
#set text(fill: rgb("#e6edf3"), size: 13pt)

$ n = w/M quad quad P V = n R T quad quad R = 0.082 " atm·L·mol"^(-1) "K"^(-1) $

#pagebreak()

$ x_i = n_i/n_t quad quad p_i = x_i P quad quad P = sum_i p_i $

#pagebreak()

$ sum F = 0: quad (P_(z+d z) - P_z) A = -m g quad => quad d P = -rho g thin d z = -(P M)/(R T) g thin d z $

#pagebreak()

$ P = P_0 exp(-(M g (h - h_0))/(R T)) $

#pagebreak()

$ n_i (xi) = n_i^0 + nu_i xi quad cases(
  nu_i > 0 quad "productos",
  nu_i < 0 quad "reactivos"
) quad quad xi_"máx" = min_i (-n_i^0/nu_i) $

#pagebreak()

$ mat(delim: #none, align: #left,
  1 thin "atm" = 760 thin "Torr" = 101325 thin "Pa" = 14.696 thin "psi";
  1 thin "ft"^3 = 28.317 thin "L";
  T[K] = 273.15 + t[degree "C"] = 273.15 + 5/9 (t[degree "F"] - 32)
) $
