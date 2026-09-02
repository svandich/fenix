#set page(width: auto, height: auto, margin: (x: 0.5em, y: 0.3em), fill: none)
#set text(fill: rgb("#e6edf3"), size: 13pt)

$ "isobárico:" quad W = P Delta V = n R Delta T quad quad Q_P = Delta H = n C_P Delta T $

#pagebreak()

$ "adiabático:" quad Q = 0 quad => quad Delta U = -W = n C_V Delta T $

#pagebreak()

$ gamma = C_P/C_V quad quad T V^(gamma - 1) = "cte." quad quad P V^gamma = "cte." quad quad T^gamma P^(1 - gamma) = "cte." $

#pagebreak()

$ d U = lr((partial U)/(partial V))_T thin d V + C_V thin d T quad quad d H = lr((partial H)/(partial P))_T thin d P + C_P thin d T $

#pagebreak()

$ "Gas ideal:" quad lr((partial U)/(partial V))_T = 0 quad => quad lr((partial H)/(partial P))_T = 0 $

#pagebreak()

$ mu_"JT" = lr((partial T)/(partial P))_H = 1/C_P ((2a)/(R T) - b) quad quad lr((partial H)/(partial P))_T = -mu_"JT" C_P $

#pagebreak()

$ Delta H|_T = integral_(P_1)^(P_2) lr((partial H)/(partial P))_T thin d P = -integral_(P_1)^(P_2) mu_"JT" C_P thin d P = (b - (2a)/(R T)) (P_2 - P_1) $

#pagebreak()

$ Delta T = mu_"JT" Delta P quad quad C_P - C_V = R quad quad Delta H_"rxn"^circle.stroked.small = sum_i nu_i thin Delta H_(f,i)^circle.stroked.small $
