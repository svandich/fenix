#set page(width: auto, height: auto, margin: (x: 0.5em, y: 0.3em), fill: none)
#set text(fill: rgb("#e6edf3"), size: 13pt)

$ Delta U = Q - W quad quad Delta U_(a -> b) "no depende del camino"; quad Q "y" W "sí" $

#pagebreak()

$ W_"rev" = integral_(V_i)^(V_f) P_"sist" thin d V quad quad W_"irrev" = P_"op" Delta V quad quad W_"vacío" = 0 $

#pagebreak()

$ W_"rev"^"vdW" = integral_(V_i)^(V_f) ((n R T)/(V - n b) - (a n^2)/V^2) thin d V = n R T ln((V_f - n b)/(V_i - n b)) + a n^2 (1/V_f - 1/V_i) $

#pagebreak()

$ mat(delim: #none, align: #left,
  "isocórico" (d V = 0): quad W = 0, quad Q_V = Delta U = n C_V Delta T;
  "isobárico" (d P = 0): quad W = P Delta V, quad Q_P = Delta H = n C_P Delta T;
  "isotérmico" (d T = 0): quad Delta U = 0, quad Q = W = n R T ln(V_f/V_i)
) $

#pagebreak()

$ "Ciclo:" quad Delta U_"ciclo" = 0 quad => quad W_"neto" = Q_"neto" = sum_i W_i $
