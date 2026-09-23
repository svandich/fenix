#set page(width: auto, height: auto, margin: (x: 0.5em, y: 0.3em), fill: none)
#set text(fill: rgb("#e6edf3"), size: 13pt)

$ Delta H_"rxn"^circle.stroked.small = sum_"prod" nu_i Delta H_(f,i)^circle.stroked.small - sum_"reac" nu_j Delta H_(f,j)^circle.stroked.small quad quad Delta H^(g) = Delta H^(l) + n_(H_2 O) Delta H_"vap" $

#pagebreak()

$ Delta H_2 = Delta H_1 + integral_(T_1)^(T_2) Delta C_P thin d T quad quad Delta C_P = sum_"prod" nu_i C_(P,i) - sum_"reac" nu_j C_(P,j) $

#pagebreak()

$ eta = W_"neto"/Q_"absorbido" = (Q_"abs" + Q_"ced")/Q_"abs" = 1 + Q_"ced"/Q_"abs" $

#pagebreak()

$ eta = 1 - gamma (T_B - T_C)/(T_A - T_C) = 1 - gamma (V_B \/ V_A - 1)/(P_A \/ P_B - 1) $

#pagebreak()

$ mat(delim: #none, align: #left,
  "isocórico:", quad W = 0, quad Q = Delta U = n C_V Delta T;
  "isobárico:", quad W = P Delta V, quad Q = Delta H = n C_P Delta T;
  "isotérmico rev.:", quad Delta U = 0, quad Q = W = n R T ln (V_2 \/ V_1);
  "adiabático rev.:", quad Q = 0, quad W = -Delta U = -n C_V Delta T
) $

#pagebreak()

$ gamma = C_P/C_V quad quad P V^gamma = "cte." quad quad T V^(gamma - 1) = "cte." quad quad T^gamma P^(1 - gamma) = "cte." $

#pagebreak()

$ Delta S = n C_V ln (T_2/T_1) + n R ln (V_2/V_1) = n C_P ln (T_2/T_1) - n R ln (P_2/P_1) $

#pagebreak()

$ Delta S_"transición" = Delta H_"transición"/T_"transición" quad quad Delta S_"calent." = integral_(T_1)^(T_2) (n C_P)/T thin d T = n C_P ln (T_2/T_1) $

#pagebreak()

$ Delta S = underbrace(n C_P^(l) ln (273/263), "calentar el líquido a 0 °C") + underbrace(-(n Delta H_"fus")/273, "congelar a 0 °C") + underbrace(n C_P^(s) ln (263/273), "enfriar el hielo a −10 °C") $
