#set page(width: auto, height: auto, margin: (x: 0.5em, y: 0.3em), fill: none)
#set text(fill: rgb("#e6edf3"), size: 13pt)

$ Delta H_"rxn"^circle.stroked.small = sum_"prod" nu_i Delta H_(f,i)^circle.stroked.small - sum_"reac" nu_j Delta H_(f,j)^circle.stroked.small $

#pagebreak()

$ "invertir:" quad Delta H arrow.r -Delta H quad quad "multiplicar por " n colon quad Delta H arrow.r n Delta H quad quad "sumar:" quad Delta H_1 + Delta H_2 $

#pagebreak()

$ "Cámara adiabática:" quad Delta H_"total" = 0 = underbrace(Delta H_"rxn"^circle.stroked.small (298), "reacción a 298 K") + underbrace(integral_298^(T_"llama") sum_"prod" n_i C_(P,i) thin d T, "calentar los productos") $

#pagebreak()

$ Delta H_"calent." = sum_"prod" n_i [ C_(P,i)^(l) (T_"eb" - 298) + Delta H_"vap,i" + C_(P,i)^(g) (T_"llama" - T_"eb") ] $

#pagebreak()

$ alpha = 1/V lr(( (partial V)/(partial T) ))_P quad quad beta = 1/P lr(( (partial P)/(partial T) ))_V quad quad kappa = alpha/(P beta) = -1/V lr(( (partial V)/(partial P) ))_T $

#pagebreak()

$ (P + a/V^2)(V - b) = R T quad quad lr(( (partial P)/(partial T) ))_V = R/(V - b) quad quad lr(( (partial V)/(partial T) ))_P = R/(P - a/V^2 + (2 a b)/V^3) $

#pagebreak()

$ "isocórico:" quad W = 0, quad Q = Delta U = n integral C_V thin d T quad quad "isotérmico rev.:" quad Delta U = 0, quad Q = W = n R T ln (V_2/V_1) $

#pagebreak()

$ C_P/R = 1 + a T quad => quad C_V = C_P - R = a R T quad => quad Delta U = n integral_(T_1)^(T_2) a R T thin d T = (n a R)/2 (T_2^2 - T_1^2) $

#pagebreak()

$ "Recta " P "–" V colon quad P = P_1 + m (V - V_1) quad => quad W = integral_(V_1)^(V_2) P thin d V = ((P_1 + P_2)/2)(V_2 - V_1) $

#pagebreak()

$ "Aire:" quad y_(O_2) = 0.21 quad => quad V_"aire" = (n_(O_2) R T)/(0.21 thin P) $
