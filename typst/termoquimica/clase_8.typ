#set page(width: auto, height: auto, margin: (x: 0.5em, y: 0.3em), fill: none)
#set text(fill: rgb("#e6edf3"), size: 13pt)

$ Delta H_"total" = sum_i Delta H_i quad quad ("Ley de Hess: " Delta H "no depende del camino") $

#pagebreak()

$ mat(delim: #none, align: #left,
  "C"("grafito") + 1/2 "O"_2 (g) -> "CO"(g), quad Delta H_1;
  "CO"(g) + 1/2 "O"_2 (g) -> "CO"_2 (g), quad Delta H_2;
  "C"("grafito") + "O"_2 (g) -> "CO"_2 (g), quad Delta H_3 = Delta H_1 + Delta H_2
) $

#pagebreak()

$ a A + b B -> c C + d D quad quad Delta H_2 = Delta H' + Delta H_1 + Delta H'' $

#pagebreak()

$ Delta H' = -integral_(T_1)^(T_2) (a C_P^A + b C_P^B) thin d T quad quad Delta H'' = integral_(T_1)^(T_2) (c C_P^C + d C_P^D) thin d T $

#pagebreak()

$ Delta C_P^circle.stroked.small = C_P^circle.stroked.small ("productos") - C_P^circle.stroked.small ("reactivos") = sum_"prod" nu_i C_(P,i)^circle.stroked.small - sum_"reac" nu_j C_(P,j)^circle.stroked.small $

#pagebreak()

$ Delta H_2 = Delta H_1 + integral_(T_1)^(T_2) Delta C_P thin d T quad quad ("ecuación de Kirchhoff") $

#pagebreak()

$ Delta C_P = "cte." quad => quad Delta H_2 = Delta H_1 + Delta C_P (T_2 - T_1) = Delta H_1 + Delta C_P Delta T $
